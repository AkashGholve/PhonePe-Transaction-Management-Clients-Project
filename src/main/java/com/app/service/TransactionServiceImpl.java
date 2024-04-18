package com.app.service;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.app.entity.Transaction;
import com.app.repository.TransactionRepository;

@Service
public class TransactionServiceImpl implements TransactionService {

    private final TransactionRepository transactionRepository;

    public TransactionServiceImpl(TransactionRepository transactionRepository) {
        this.transactionRepository = transactionRepository;
    }

    @Override
    @Transactional
    public void processTransactionsFromPdf(MultipartFile file) throws IOException {

        try (InputStream inputStream = file.getInputStream()) {
            PDDocument document = PDDocument.load(inputStream);
            PDFTextStripper stripper = new PDFTextStripper();
            String pdfText = stripper.getText(document);
            document.close();

            String[] lines = pdfText.split("\\r?\\n");
            String transactionId = null;
            String transactionAmount = null;
            String transactionDate = null;
            String transactionType = null;

            for (int i = 0; i < lines.length; i++) {
                String line = lines[i];
                String nextLine = i + 1 < lines.length ? lines[i + 1] : null;

                if (line.contains("Transaction ID")) {
                    transactionId = extractValue(line, "Transaction ID");

                    if (transactionType == "DEBIT" && nextLine != null && nextLine.trim().matches("^[A-Z0-9]+$")) {
                        transactionId = nextLine.trim();
                        i++;
                    }
                } else if (line.contains("Received from") || line.contains("Paid to") || line.contains("Transfer to ")) {
                    transactionType = line.contains("Received from") ? "CREDIT" : "DEBIT";
                    transactionAmount = extractAmount(line);
                } else if (line.matches("^\\w{3} \\d{1,2}, \\d{4}$")) {
                    transactionDate = line;
                }

                if (transactionId != null && transactionAmount != null && transactionDate != null
                        && transactionType != null) {
                    Transaction transaction = new Transaction();
                    transaction.settransaction_id(transactionId);
                    transaction.settransaction_amount(transactionAmount);
                    transaction.settransaction_date(transactionDate);
                    transaction.settransaction_type(transactionType);
                    transaction.setTransactionFileName(file.getOriginalFilename());

                    transactionRepository.save(transaction);

                    transactionId = null;
                    transactionAmount = null;
                    transactionDate = null;
                    transactionType = null;
                }
            }
        }
    }

    private String extractValue(String line, String keyword) {
        int index = line.indexOf(keyword) + keyword.length();
        return line.substring(index).trim();
    }

    private String extractAmount(String line) {
        Pattern pattern = Pattern.compile("[₹]?([0-9,]+[.]?[0-9]{0,2})");
        Matcher matcher = pattern.matcher(line);
        if (matcher.find()) {
            return matcher.group(1).replaceAll(",", "");
        }
        return null;
    }

    @Override
    public Page<Transaction> getAllTransactions(Pageable pageable) {
        return transactionRepository.findAll(pageable);
    }

    @Override
    public List<String> getUploadedFiles() {
        return transactionRepository.getUploadedFileNames();
    }

    @Override
    public Page<Transaction> getTransactionsByFileName(String filename, Pageable pageable) {
        return transactionRepository.findByTransactionFileName(filename, pageable);
    }

    @Override
    public List<Transaction> getAllTransactions() {
        return transactionRepository.findAll();
    }

    @Override
    public List<Transaction> getTransactionsByFileName(String fileName) {
        return transactionRepository.findByTransactionFileName(fileName);
    }
}
