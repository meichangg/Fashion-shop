package com.myshop.model;

import java.math.BigDecimal;

public class Product {

    private int productID;
    private int categoryID;
    private String productName;
    private String description;
    private BigDecimal price;
    private int discountPercent;
    private int stock;
    private String thumbnailUrl;

    // ==========================
    // GETTER & SETTER
    // ==========================

    public int getProductID() {
        return productID;
    }

    public void setProductID(int productID) {
        this.productID = productID;
    }

    public int getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(int categoryID) {
        this.categoryID = categoryID;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(int discountPercent) {
        this.discountPercent = discountPercent;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public String getThumbnailUrl() {
        return thumbnailUrl;
    }

    public void setThumbnailUrl(String thumbnailUrl) {
        this.thumbnailUrl = thumbnailUrl;
    }

    // ==========================
    // GIÁ SAU KHUYẾN MÃI
    // ==========================
    public BigDecimal getFinalPrice() {
        if (price == null) return BigDecimal.ZERO;

        if (discountPercent <= 0) {
            return price;
        }

        return price.subtract(
                price.multiply(new BigDecimal(discountPercent))
                     .divide(new BigDecimal(100))
        );
    }
}
