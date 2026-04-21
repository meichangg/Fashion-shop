package com.myshop.controller;

import com.myshop.dao.CustomerDAO;
import com.myshop.dao.OrderDAO;
import com.myshop.dao.ProductDAO;   // ⭐ THÊM DÒNG NÀY
import com.myshop.model.CartItem;
import com.myshop.model.Customer;
import com.myshop.model.Product;   // ⭐ THÊM DÒNG NÀY

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.Map;

@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout"})
public class CheckoutServlet extends HttpServlet {

    @SuppressWarnings("unchecked")
    private Map<Integer, CartItem> getCart(HttpSession session) {
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new LinkedHashMap<>();
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    private static final int CURRENT_CUSTOMER_ID = 1;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Map<Integer, CartItem> cart = getCart(session);

        if (cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        try {
            CustomerDAO cdao = new CustomerDAO();
            Customer customer = cdao.findById(CURRENT_CUSTOMER_ID);

            BigDecimal total = BigDecimal.ZERO;
            for (CartItem item : cart.values()) {
                total = total.add(item.getLineTotal());
            }

            request.setAttribute("customer", customer);
            request.setAttribute("cartTotal", total);

            request.getRequestDispatcher("/WEB-INF/views/checkout.jsp")
                    .forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Map<Integer, CartItem> cart = getCart(session);
        if (cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        String addressChoice = request.getParameter("addressChoice");
        String savedAddress = request.getParameter("savedAddress");
        String newAddress = request.getParameter("newAddress");
        String paymentMethod = request.getParameter("paymentMethod");

        String finalAddress;
        if ("new".equals(addressChoice)) {
            finalAddress = newAddress != null ? newAddress.trim() : "";
        } else {
            finalAddress = savedAddress != null ? savedAddress.trim() : "";
        }

        if (finalAddress.isEmpty() || paymentMethod == null || paymentMethod.isEmpty()) {
            request.setAttribute("error", "Vui lòng chọn địa chỉ và phương thức thanh toán.");
            doGet(request, response);
            return;
        }

        try {
            // ⭐⭐ KIỂM TRA TỒN KHO TRƯỚC KHI TẠO ĐƠN ⭐⭐
            ProductDAO pdao = new ProductDAO();

            for (CartItem item : cart.values()) {
                Product p = pdao.findById(item.getProduct().getProductID());    

                if (p.getStock() < item.getQuantity()) {
                    request.setAttribute("error",
                            "Sản phẩm \"" + p.getProductName() +
                            "\" chỉ còn " + p.getStock() + " sản phẩm trong kho. " +
                            "Vui lòng giảm số lượng hoặc chọn sản phẩm khác.");

                    // Giữ lại thông tin checkout
                    request.setAttribute("customer", new CustomerDAO().findById(CURRENT_CUSTOMER_ID));

                    // Gửi lại tổng tiền
                    BigDecimal total = BigDecimal.ZERO;
                    for (CartItem ci : cart.values()) total = total.add(ci.getLineTotal());
                    request.setAttribute("cartTotal", total);

                    request.getRequestDispatcher("/WEB-INF/views/checkout.jsp")
                            .forward(request, response);
                    return;
                }
            }
            // ⭐⭐ HẾT PHẦN CHECK TỒN KHO ⭐⭐


            OrderDAO odao = new OrderDAO();
            int orderId = odao.createOrder(CURRENT_CUSTOMER_ID, finalAddress, paymentMethod, cart);

            cart.clear();

            request.setAttribute("orderId", orderId);
            request.setAttribute("paymentMethod", paymentMethod);
            request.setAttribute("shippingAddress", finalAddress);

            request.getRequestDispatcher("/WEB-INF/views/order-success.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
