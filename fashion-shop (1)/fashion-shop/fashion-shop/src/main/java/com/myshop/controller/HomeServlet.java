package com.myshop.controller;

import com.myshop.dao.CategoryDAO;
import com.myshop.dao.ProductDAO;
import com.myshop.model.Category;
import com.myshop.model.Product;
import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String q = request.getParameter("q");
        String cidStr = request.getParameter("cid");
        Integer cid = null;
        if (cidStr != null && !cidStr.isEmpty()) {
            try {
                cid = Integer.parseInt(cidStr);
            } catch (NumberFormatException e) {
                cid = null;
            }
        }

        try {
            CategoryDAO catDao = new CategoryDAO();
            ProductDAO proDao = new ProductDAO();

            List<Category> categories = catDao.getAllActive();
            List<Product> products = proDao.search(q, cid);

            request.setAttribute("categories", categories);
            request.setAttribute("products", products);
            request.setAttribute("keyword", q);
            request.setAttribute("selectedCid", cid);

            request.getRequestDispatcher("/WEB-INF/views/home.jsp")
                   .forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
