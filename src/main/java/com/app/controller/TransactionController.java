package com.app.controller;

import java.io.IOException;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.app.entity.Transaction;
import com.app.service.TransactionService;

@Controller
public class TransactionController {

	private final TransactionService transactionService;

	public TransactionController(TransactionService transactionService) {
		this.transactionService = transactionService;
	}

	@GetMapping("/upload")
	public String showUploadForm() {
		return "upload-form";
	}

	@PostMapping("/upload")
	public String uploadFile(@RequestParam("file") MultipartFile file) {
//		System.out.println("IN post /upload " + file.getName());
		if (file.isEmpty()) {
			return "redirect:/upload";
		}
		try {
			if (!file.getContentType().equals("application/pdf")) {
				return "redirect:/upload";
			}
			transactionService.processTransactionsFromPdf(file);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return "redirect:/uploaded-files";
	}

	// transactions showing to transactions.jsp
	@GetMapping("/uploaded-files")
	public String showUploadedFiles(Model model) {
		// method add
		List<String> upploadedFiles = transactionService.getUploadedFiles();
		model.addAttribute("uploadedFiles", upploadedFiles);
		return "uploaded-files";
	}

	@GetMapping("/transactions/{filename}")
	public String showTransactionsByFilenamePagination(@PathVariable String filename,
			@RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = "10") int size, Model model) {

		// Create a Pageable object for pagination
		Pageable pageable = PageRequest.of(page, size);
		System.out.println(pageable.toString());
		// Retrieve a page of transactions for the given filename
		Page<Transaction> transactionsPage;

		if (filename != null) {
			transactionsPage = transactionService.getTransactionsByFileName(filename, pageable);
		} else {
			transactionsPage = transactionService.getAllTransactions(pageable);
		}

		 model.addAttribute("transactionsPage", transactionsPage);
		    model.addAttribute("filename", filename);
		return "transactions";
	}

	
}
