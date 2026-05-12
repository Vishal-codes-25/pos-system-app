# 🏪 Kirana POS / POS System App

A Flutter-based Point of Sale (POS) mobile application designed for quick billing, inventory management, and sales tracking for small retail businesses and kirana stores.

The app enables users to scan products, retrieve product information through APIs when available, manage inventory, and complete purchase workflows through an easy-to-use mobile interface.

The system is designed to simplify billing operations for local shops while improving product management and sales tracking.

---

## ✨ Features

- QR / barcode product scanning
- Product lookup from database
- API-based product name and price retrieval
- Product verification popup
- Inventory management
- Basic cart system
- Purchase / billing workflow
- Sales dashboard analytics
- Recent transaction history
- User profile management
- Password & security management
- Google Authentication
- Firebase Authentication
- Cash-only checkout system

---

## 🔄 Workflow

1. Scan the product QR code or barcode  
2. Search for the product in the database  
3. If the product is unavailable, call the product API  
4. If product data is found, a confirmation popup appears to verify:
   - Product name
   - Brand
   - Price
5. Save the verified product to the database  
6. Add product to cart  
7. Complete billing and purchase flow  

In some cases, product details may not be automatically retrieved because the external API may not contain pricing or product information for all items. Manual confirmation helps maintain billing accuracy.

---

## 📊 Dashboard Features

The app includes a **Sales Dashboard** to track:

- Daily Sales
- Weekly Sales
- Monthly Sales
- Yearly Sales
- Total Orders
- Recent Transactions

---

## 🛠 Tech Stack

### Mobile Development
- **Flutter**
- **Dart**

### Backend & Database
- **Firebase**
- **Cloud Firestore**

### Authentication
- **Firebase Authentication**
- **Google Sign-In Authentication**

### APIs & Services
- **Product Information APIs**
- **QR / Barcode Scanning**

---

## 💳 Payment Support

Currently supported payment method:

- **Cash Payment**

Online payment integration is planned for future updates.

---

## 🚧 Project Status

**This project is currently under active development.**

Features are continuously being improved, and API-based product retrieval may occasionally fail if external product data is unavailable.

---

## 📩 Support / Contact

If you face any issue while using or previewing the application, please contact the managing developer:

📧 **vishalpatel.work25@gmail.com**

---

⭐ *Built to simplify retail billing, inventory tracking, and sales management for local stores and kirana businesses.*
