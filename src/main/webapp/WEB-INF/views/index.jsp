<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>index</title>
     <link rel="icon" href="${pageContext.request.contextPath}/static/images/favicon.png" type="image/png">
</head>
<body>
    <h2>Hello Spring Framework</h2>
    <a href="/main">메인화면</a>


    <a href="/sale/list">판매실적 이동</a>
    <a href="/saleStmt/list">거래명세서 이동</a>
    <a href="/productCategory/list">상품카테고리 이동</a>

    <a href="/product/">상품 이동</a>
    <a href="/product/stockQuantity/">재고 이동</a>

</body>
</html>
