package com.app.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.web.multipart.MultipartFile;

import com.app.entity.Transaction;

import java.io.IOException;
import java.util.List;

//service layer for interacting with transaction related operations
public interface TransactionService {
	void processTransactionsFromPdf(MultipartFile file) throws IOException;

	// add list to show all the tx
	List<Transaction> getAllTransactions();

	List<String> getUploadedFiles();

	List<Transaction> getTransactionsByFileName(String fileName);

	Page<Transaction> getTransactionsByFileName(String filename, Pageable pageable);

	Page<Transaction> getAllTransactions(Pageable pageable);
}
