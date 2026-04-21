package com.myshop.controller;

import com.myshop.dao.ProductDAO;
import com.myshop.model.CartItem;
import com.myshop.model.Product;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {

    @SuppressWarnings("unchecked")
    private Map<Integer, CartItem> getCart(HttpSession session) {
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new LinkedHashMap<>();
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Map<Integer, CartItem> cart = getCart(session);

        try {
            ProductDAO dao = new ProductDAO();

            if ("add".equals(action)) {
                int pid = Integer.parseInt(request.getParameter("pid"));
                int qty = Integer.parseInt(request.getParameter("qty"));

                Product p = dao.findById(pid);
                if (p != null) {
                    CartItem item = cart.get(pid);
                    if (item == null) {
                        item = new CartItem(p, qty);
                    } else {
                        item.setQuantity(item.getQuantity() + qty);
                    }
                    cart.put(pid, item);
                }

            } else if ("update".equals(action)) {
                int pid = Integer.parseInt(request.getParameter("pid"));
                int qty = Integer.parseInt(request.getParameter("qty"));
                CartItem item = cart.get(pid);
                if (item != null) {
                    if (qty <= 0) cart.remove(pid);
                    else item.setQuantity(qty);
                }

            } else if ("remove".equals(action)) {
                int pid = Integer.parseInt(request.getParameter("pid"));
                cart.remove(pid);
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Map<Integer, CartItem> cart = getCart(session);

        BigDecimal total = BigDecimal.ZERO;
        for (CartItem item : cart.values()) {
            total = total.add(item.getLineTotal());
        }
        request.setAttribute("cartTotal", total);

        request.getRequestDispatcher("/WEB-INF/views/cart.jsp")
               .forward(request, response);
    }
}
