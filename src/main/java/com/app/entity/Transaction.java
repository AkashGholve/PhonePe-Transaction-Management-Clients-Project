package com.app.entity;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class Transaction {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String transaction_id;
    private String transaction_amount;
    private String transaction_date;
    private String transaction_type;
    private String transactionFileName;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String gettransaction_id() {
        return transaction_id;
    }

    public void settransaction_id(String transactionId) {
        this.transaction_id = transactionId;
    }

    public String gettransaction_amount() {
        return transaction_amount;
    }

    public void settransaction_amount(String transactionAmount) {
        this.transaction_amount = transactionAmount;
    }

    public String gettransaction_date() {
        return transaction_date;
    }

    public void settransaction_date(String transactionDate) {
        this.transaction_date = transactionDate;
    }

    public String gettransaction_type() {
        return transaction_type;
    }

    public void settransaction_type(String transactionType) {
        this.transaction_type = transactionType;
    }

    public String gettransactionFileName() {
        return transactionFileName;
    }

    public void setTransactionFileName(String transactionFileName) {
        this.transactionFileName = transactionFileName;
    }
}
