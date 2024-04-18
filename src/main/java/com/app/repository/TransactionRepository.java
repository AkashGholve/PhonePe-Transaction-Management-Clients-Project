package com.app.repository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.app.entity.Transaction;

public interface TransactionRepository extends JpaRepository<Transaction, Long> {
	// Method to retrieve the list of uploaded file names on upload-files.jsp (file names)
	
    @Query("SELECT DISTINCT t.transactionFileName FROM Transaction t")
    List<String> getUploadedFileNames();
    
    // Method to retrieve transactions by file name
    List<Transaction> findByTransactionFileName(String fileName);
    Page<Transaction> findByTransactionFileName(String transactionFileName, Pageable pageable);
}
