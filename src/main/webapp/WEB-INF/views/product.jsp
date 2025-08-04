<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/header.jsp" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>index</title>
     <meta name="viewport" content="width=device-width, initial-scale=1">
     <script src="${pageContext.request.contextPath}/webjars/chartjs/2.9.4/Chart.min.js"></script>
     <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
     <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/chart.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/chart.css"/>

</head>
<style>

</style>
<body>
	<div id="product" class="container">
        <div>
          <table>
            <thead>
                <tr>
                  <th>대분류</th>
                  <th>중분류</th>
                  <th>상품코드</th>
                  <th>상품명</th>
                  <th>상품가격</th>
                  <th>재고수량</th>
                  <th>등록일시</th>
                  <th></th>
                  <th></th>
                </tr>
            </thead>
            <tbody>
               <c:forEach items="${categoryList}" var="parent">
                    <c:if test="${parent.categoryLevel == 1}">
                        <c:forEach items="${parent.categoryList}" var="middle">
                             <c:if test="${middle.categoryLevel == 2}">
                                 <c:forEach items="${middle.productList}" var="product">
                                    <tr>
                                        <td>${parent.categoryName }</td>
                                        <td>${middle.categoryName }</td>
                                        <td>${product.productId }</td>
                                        <td>${product.productName }</td>
                                        <td>${product.price}</td>
                                        <td>${product.stockQuantity}</td>
                                        <td>${product.createdAt }</td>
                                        <td><button>수정</button></td>
                                        <td><button onclick="deleteFn(${product.productId})">삭제</button></td>
                                    </tr>
                                 </c:forEach>
                             </c:if>
                          </c:forEach>
                     </c:if>
                </c:forEach>
           </tbody>
          </table>
        </div>
	</div>
</body>
<script>
   const deleteFn = (productId) => {
    console.log("productId: " + productId);
    const confirmed = confirm("상품을 삭제하시겠습니까?");
    if(confirmed) {
     location.href = "/product/delete?id=" + productId;
    }
   }

  //const updateFn = (productId) => {
   //if(confirm("상품을 수정하시겠습니까?")) {
    //location.href = "/product/update?id=" + productId;
   //}
  //}
</script>
</html>
