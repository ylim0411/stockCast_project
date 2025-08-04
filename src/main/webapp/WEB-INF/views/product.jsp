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

	<script>
       const deleteFn = (productId) => {
        console.log("productId: " + productId);
        const confirmed = confirm("상품을 삭제하시겠습니까?");
        if(confirmed) {
         location.href = "/product/delete?id=" + productId;
        }
       }

          const updateFn = (btn) => {
            const row = btn.closest("tr");
            const inputs = row.querySelectorAll("input, select");

            let isReadOnly = row.classList.contains("editing");

            inputs.forEach(input => {
              if (!input.name.includes("productId") && !input.name.includes("createdAt")) {
                if (isReadOnly) {
                  input.setAttribute("readonly", true);
                  input.setAttribute("disabled", true);
                } else {
                  input.removeAttribute("readonly");
                  input.removeAttribute("disabled");
                }
              }
            });

            row.classList.toggle("editing");
          };

        const categoryList = [
            <c:forEach var="parent" items="${categoryList}" varStatus="i">
                {
                    categoryId: ${parent.categoryId},
                    categoryName: "${parent.categoryName}",
                    categoryLevel: ${parent.categoryLevel},
                    parentId: ${parent.parentId},
                    categoryList: [
                        <c:forEach var="middle" items="${parent.categoryList}" varStatus="j">
                            {
                                categoryId: ${middle.categoryId},
                                categoryName: "${middle.categoryName}",
                                categoryLevel: ${middle.categoryLevel},
                                parentId: ${middle.parentId}
                            }<c:if test="${!j.last}">,</c:if>
                        </c:forEach>
                    ]
                }<c:if test="${!i.last}">,</c:if>
            </c:forEach>
        ];

    </script>
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
                                 <form method="post" action="${pageContext.request.contextPath}/product/update">
                                    <tr data-product-id="${product.productId}">
                                            <td>
                                              <select name="parentCategoryId" disabled>
                                                <c:forEach items="${categoryList}" var="parentOption">
                                                  <option value="${parentOption.categoryId}"
                                                    <c:if test="${parentOption.categoryId == middle.parentId}">selected</c:if>>
                                                    ${parentOption.categoryName}
                                                  </option>
                                                </c:forEach>
                                              </select>
                                            </td>

                                            <td>
                                              <select name="middleCategoryId" disabled>
                                                <c:forEach items="${parent.categoryList}" var="middleOption">
                                                  <option value="${middleOption.categoryId}"
                                                    <c:if test="${middleOption.categoryId == middle.categoryId}">selected</c:if>>
                                                    ${middleOption.categoryName}
                                                  </option>
                                                </c:forEach>
                                              </select>
                                            </td>

                                            <td><input type="text" name="productId" value="${product.productId}" readonly /></td>
                                            <td><input type="text" name="productName" value="${product.productName}" readonly /></td>
                                            <td><input type="text" name="price" value="${product.price}" readonly /></td>
                                            <td><input type="text" name="stockQuantity" value="${product.stockQuantity}" readonly /></td>
                                            <td><input type="text" value="${product.createdAt}" readonly /></td>

                                            <td><button type="button" onclick="updateFn(this)">수정</button></td>
                                            <td><button type="submit">저장</button></td>
                                            <td><button onclick="deleteFn(${product.productId})">삭제</button></td>

                                      </tr>
                                      </form>
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

</html>
