<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/header.jsp" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>index</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">


  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css"/>


</head>
<body>
  <div id="product" class="container">
    <div class="title-box">
        <p class="sub-title">상품 관리</p>
        <h2 class="title">전체 상품 목록</h2>
    </div>
    <div class="section-wrap">
      <form action="/product/search" method="get">
        <div class="form-container"> 
          <div class="btn-box">
            <input type="text" name="productName" placeholder="상품명 검색" value="${param.productName}"/>
            <button type="submit" class="btn btn-blue">검색</button>
          </div>
          <button class="addRow btn btn-blue" type="button">상품 등록</button>
        </div>
      </form>
      <div class="table-container">
      <table class="productTable">
        <thead>
          <tr>
            <th>대분류</th>
            <th>중분류</th>
            <th></th>
            <th>상품코드</th>
            <th>상품명</th>
            <th>상품가격</th>
            <th>재고수량</th>
            <th>등록일시</th>
            <th>수정</th>
            <th>저장</th>
          </tr>
        </thead>
        <tbody>
          <c:if test="${not empty searchResult}"> <!-- 수정됨 -->
            <c:forEach items="${searchResult}" var="product"> <!-- 수정됨 -->
              <tr data-product-id="${product.productId}">
                <form method="post" action="${pageContext.request.contextPath}/product/update">
                  <td colspan="2"> <!-- 대분류/중분류 표시 생략 또는 선택 불가능하게 처리 -->
                    <select name="parentCategoryId" disabled><option>선택 불가</option></select>
                    <select name="middleCategoryId" disabled><option>선택 불가</option></select>
                  </td>
                  <td><input type="hidden" name="storeId" value="${product.storeId}" readonly /></td>
                  <td><input type="text" name="productId" value="${product.productId}" readonly /></td>
                  <td><input type="text" name="productName" value="${product.productName}" readonly /></td>
                  <td><input type="number" name="price" value="${product.price}" readonly /></td>
                  <td><input type="number" name="stockQuantity" value="${product.stockQuantity}" readonly /></td>
                  <td><input type="text" name="createdAt" value="${product.createdAt}" readonly /></td>
                  <td><button type="button" onclick="updateFn(this)">수정</button></td>
                  <td><button type="submit" class="saveBtn" style="display:none;">저장</button></td>
                </form>
              </tr>
            </c:forEach>
          </c:if>
            <c:if test="${empty searchResult}">
              <c:forEach items="${categoryList}" var="parent">
                <c:if test="${parent.categoryLevel == 1}">
                  <c:forEach items="${parent.categoryList}" var="middle">
                    <c:if test="${middle.categoryLevel == 2}">
                      <c:forEach items="${middle.productList}" var="product">
                        <tr data-product-id="${product.productId}">
                          <form method="post" action="${pageContext.request.contextPath}/product/update">
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
                            <td><input type="hidden" name="storeId" value="${product.storeId}" readonly /></td>
                            <td><input type="text" name="productId" value="${product.productId}" readonly /></td>
                            <td><input type="text" name="productName" value="${product.productName}" readonly /></td>
                            <td><input type="number" name="price" value="${product.price}" readonly /></td>
                            <td><input type="number" name="stockQuantity" value="${product.stockQuantity}" readonly /></td>
                            <td><input type="text" name="createdAt" value="${product.createdAt}" readonly /></td>
                            <td><button type="button" onclick="updateFn(this)">수정</button></td>
                            <td><button type="submit" class="saveBtn" style="display:none;">저장</button></td>
                          </form>
                        </tr>
                      </c:forEach>
                    </c:if>
                  </c:forEach>
                </c:if>
              </c:forEach>
            </c:if>
            <tr class="productAdd" style="display: none;">
              <form method="post" action="${pageContext.request.contextPath}/product/add">
                <td>
                  <select name="addParentCategoryId">
                    <option>대분류를 선택하세요.</option>
                      <c:forEach items="${categoryList}" var="parent">
                        <c:if test="${parent.categoryLevel == 1}">
                          <option value="${parent.categoryId}">${parent.categoryName}</option>
                        </c:if>
                      </c:forEach>
                  </select>
                </td>
                <td>
                  <select name="addMiddleCategoryId">
                    <option value="">중분류를 선택하세요.</option>
                  </select>
                </td>
                <td><input type="hidden" name="addStoreId" readonly /></td>
                <td><input type="text" name="addProductId" readonly /></td>
                <td><input type="text" name="addProductName" /></td>
                <td><input type="number" name="addPrice" /></td>
                <td><input type="number" name="addStockQuantity" /></td>
                <td><input type="text" name="addCreatedAt" readonly /></td>
                <td><button type="button" class="addBtn">등록</button></td>
              </form>
            </tr>
        </tbody>
      </table>
      </div>
    </div>
  </div>
</body>

<script>
  const categoryList = [
    <c:forEach items="${categoryList}" var="parent" varStatus="i">
      {
        categoryId: ${parent.categoryId},
        categoryName: "${parent.categoryName}",
        categoryLevel: ${parent.categoryLevel},
        childCategories: [
          <c:forEach items="${parent.categoryList}" var="middle" varStatus="j">
            {
              categoryId: ${middle.categoryId},
              categoryName: "${middle.categoryName}",
              categoryLevel: ${middle.categoryLevel}
            }<c:if test="${!j.last}">,</c:if>
          </c:forEach>
        ]
      }<c:if test="${!i.last}">,</c:if>
    </c:forEach>
  ];

  $(document).ready(function () {

    window.updateFn = (btn) => {
      const row = btn.closest("tr");
      const inputs = row.querySelectorAll("input, select");
      const saveBtn = row.querySelector(".saveBtn");
      const isEditing = row.classList.toggle("editing");

      inputs.forEach(input => {
        if (!input.name.includes("productId") && !input.name.includes("createdAt")) {
          input.disabled = !isEditing;
          input.readOnly = !isEditing;
        }
      });

      if (saveBtn) {
        saveBtn.style.display = isEditing ? "inline-block" : "none";
      }

      btn.textContent = isEditing ? "취소" : "수정";
    };

    $(".addRow").click(function () {
        let $templateRow = $(".productAdd").first();
        let $newRow = $templateRow.clone(true);
        $newRow.removeClass("productAdd");
        $newRow.removeAttr("style");
        $newRow.find("input").val("");

        $("table tbody").append($newRow);
    });

    $(document).on("change", "select[name='addParentCategoryId']", function () {
      const selectParentId = parseInt($(this).val());
      const $middleSelect = $(this).closest("tr").find("select[name='addMiddleCategoryId']");
      $middleSelect.empty();

      const selectParent = categoryList.find(cat => cat.categoryId === selectParentId);
         if (selectParent && selectParent.childCategories) {
           selectParent.childCategories.forEach(child => {
          $middleSelect.append(
            $("<option>").val(child.categoryId).text(child.categoryName)
          );
        });
      } else {
        $middleSelect.append($("<option>").val("").text("중분류 없음"));
      }
    });
  });
</script>
</html>
