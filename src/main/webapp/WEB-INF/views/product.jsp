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
  <div id="product" class="containerAuto">
    <div class="title-box">
        <p class="sub-title">상품 관리</p>
        <h2 class="title">전체 상품 목록</h2>
    </div>
    <div class="section-wrap">
      <form action="/product/list" method="get">
        <div class="form-container">
          <div class="btn-box">
            <input type="text" name="productName" placeholder="상품명 검색" value="${param.productName}"/>
            <button type="submit" class="btn btn-blue">검색</button>
          </div>
          <button class="addRow btn btn-blue" type="button">상품 등록</button>
        </div>
      </form>
      <form id="addForm-template" method="post" action="${pageContext.request.contextPath}/product/add">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
      </form>
      <div class="table-container">
      <table class="productTable">
        <thead>
          <tr>
            <th>대분류</th>
            <th>중분류</th>
            <!-- <th></th> -->
            <th>상품코드</th>
            <th>상품명</th>
            <th>상품가격</th>
            <th>재고수량</th>
            <th>등록일자</th>
            <th>수정</th>
            <th>저장</th>
          </tr>
        </thead>
        <tbody>
          <c:if test="${not empty searchResult}">
            <c:forEach items="${searchResult}" var="product">
              <tr data-product-id="${product.productId}">
                <form method="post" action="${pageContext.request.contextPath}/product/update">
                  <td colspan="2">
                    <select name="parentCategoryId" disabled>
                      <c:forEach items="${categoryList}" var="parentOption">
                        <c:if test="${parentOption.categoryLevel == 1 && parentOption.storeId == sessionScope.selectedStoredId}">
                          <option value="${parentOption.categoryId}"
                            <c:if test="${parentOption.categoryId == product.parentCategoryId}">selected</c:if>>
                            ${parentOption.categoryName}
                          </option>
                        </c:if>
                      </c:forEach>
                    </select>
                    <select name="middleCategoryId" disabled>
                      <c:forEach items="${categoryList}" var="parent">
                        <c:if test="${parent.categoryLevel == 1 && parent.storeId == sessionScope.selectedStoredId}">
                          <c:forEach items="${parent.categoryList}" var="middleOption">
                            <option value="${middleOption.categoryId}"
                              <c:if test="${middleOption.categoryId == product.middleCategoryId}">selected</c:if>>
                              ${middleOption.categoryName}
                            </option>
                          </c:forEach>
                        </c:if>
                      </c:forEach>
                    </select>
                  </td>
                  <%-- <td><input type="hidden" name="storeId" value="${product.storeId}" readonly /></td> --%>
                  <td><input type="text" name="productId" value="${product.productId}" readonly /></td>
                  <td><input type="text" name="productName" value="${product.productName}" readonly /></td>
                  <td><input type="number" name="price" value="${product.price}" readonly /></td>
                  <td><input type="number" name="stockQuantity" value="${product.stockQuantity}" readonly /></td>
                  <td>
                    <input type="text" name="createdAt"
                           value="${product.createdAt != null ? fn:substring(product.createdAt, 0, 10) : ''}"
                           readonly />
                  </td>
                  <td><button type="button" onclick="updateFn(this)">수정</button></td>
                  <td><button type="submit" class="saveBtn" style="display:none;">저장</button></td>
                </form>
              </tr>
            </c:forEach>
          </c:if>

          <c:if test="${empty searchResult}">
            <c:forEach items="${categoryList}" var="parent">
              <c:if test="${parent.categoryLevel == 1 && parent.storeId == sessionScope.selectedStoredId}">
                <c:forEach items="${parent.categoryList}" var="middle">
                  <c:if test="${middle.categoryLevel == 2}">
                    <c:forEach items="${middle.productList}" var="product">
                      <tr data-product-id="${product.productId}">
                        <form method="post" action="${pageContext.request.contextPath}/product/update">
                          <td>
                            <select name="parentCategoryId" disabled>
                              <c:forEach items="${categoryList}" var="parentOption">
                                <c:if test="${parentOption.categoryLevel == 1 && parentOption.storeId == sessionScope.selectedStoredId}">
                                  <option value="${parentOption.categoryId}"
                                    <c:if test="${parentOption.categoryId == middle.parentId}">selected</c:if>>
                                    ${parentOption.categoryName}
                                  </option>
                                </c:if>
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
                          <%-- <td><input type="hidden" name="storeId" value="${product.storeId}" readonly /></td> --%>
                          <td><input type="text" name="productId" value="${product.productId}" readonly /></td>
                          <td><input type="text" name="productName" value="${product.productName}" readonly /></td>
                          <td><input type="number" name="price" value="${product.price}" readonly /></td>
                          <td><input type="number" name="stockQuantity" value="${product.stockQuantity}" readonly /></td>
                          <td>
                            <input type="text" name="createdAt"
                                   value="${product.createdAt != null ? fn:substring(product.createdAt, 0, 10) : ''}"
                                   readonly />
                           </td>
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

          <tr class="productAdd" style="display:none;">
            <td>
              <select name="addParentCategoryId" form="addForm-template" required>
                <option value="">대분류를 선택하세요.</option>
                <c:forEach items="${categoryList}" var="parent">
                  <c:if test="${parent.categoryLevel == 1 && parent.storeId == sessionScope.selectedStoredId}">
                    <option value="${parent.categoryId}">${parent.categoryName}</option>
                  </c:if>
                </c:forEach>
              </select>
            </td>
            <td>
              <select name="addMiddleCategoryId" form="addForm-template" required>
                <option value="">중분류를 선택하세요.</option>
              </select>
            </td>
            <!-- <td><input type="hidden" name="addStoreId" form="addForm-template" /></td> -->
            <td><input type="text"   name="addProductId" form="addForm-template" readonly /></td>
            <td><input type="text"   name="addProductName" form="addForm-template" required /></td>
            <td><input type="number" name="addPrice" form="addForm-template" required /></td>
            <td><input type="number" name="addStockQuantity" form="addForm-template" required /></td>
            <td>
                <input type="text" name="createdAt"
                       value="${product.createdAt != null ? fn:substring(product.createdAt, 0, 10) : ''}"
                       readonly />
            </td>
            <td><button type="submit" class="addBtn" form="addForm-template">등록</button></td>
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
      <c:if test="${parent.categoryLevel == 1 && parent.storeId == sessionScope.selectedStoredId}">
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
      </c:if>
    </c:forEach>
  ];

  $(document).ready(function () {

        window.updateFn = (btn) => {
          const row = btn.closest("tr");
          const inputs = row.querySelectorAll("input, select");
          const saveBtn = row.querySelector(".saveBtn");
          const isEditing = row.classList.toggle("editing");

          if (isEditing) {
            // 편집 진입: 원본 저장 + enable
            inputs.forEach(el => {
              const tag = el.tagName.toLowerCase();
              if (tag === "select" || ["text","number"].includes(el.type)) {
                el.dataset.orig = el.value;
              }
              if (!el.name?.includes("productId") && !el.name?.includes("createdAt")) {
                if (tag === "select") el.disabled = false;
                else el.readOnly = false;
              }
            });
            if (saveBtn) saveBtn.style.display = "inline-block";
            btn.textContent = "취소";

            // 첫 번째 편집 가능 요소 포커스
            const editableList = [...inputs].filter(el => {
              if (el.name?.includes("productId") || el.name?.includes("createdAt")) return false;
              const tag = el.tagName.toLowerCase();
              if (tag === "select") return el.disabled === false;
              if (["text","number"].includes(el.type)) return el.readOnly === false;
              return false;
            });
            const first = editableList[0];
            if (first) {
              setTimeout(() => {
                first.focus();
                if (typeof first.select === "function") { try { first.select(); } catch {} }
                if (typeof first.setSelectionRange === "function" && first.value) {
                  try { const len = first.value.length; first.setSelectionRange(len, len); } catch {}
                }
                if (first.scrollIntoView) first.scrollIntoView({ block: "nearest", inline: "nearest" });
              }, 0);
            }

          } else {

            const parentSel = row.querySelector("select[name='parentCategoryId']");
            const middleSel = row.querySelector("select[name='middleCategoryId']");
            const origParent = parentSel?.dataset.orig;
            const origMiddle = middleSel?.dataset.orig;

            // 1) 대분류 복원 + change로 중분류 옵션 재생성
            if (parentSel && origParent !== undefined) {
              parentSel.value = origParent;
              $(parentSel).trigger("change");
            }
            // 2) 중분류 값 복원 (옵션 없으면 임시 추가 후 선택)
            if (middleSel && origMiddle !== undefined) {
              const hasOption = [...middleSel.options].some(o => o.value == origMiddle);
              if (!hasOption) middleSel.append(new Option("(복원)", origMiddle));
              middleSel.value = origMiddle;
            }

            // 3) 나머지 인풋 복원 + 비활성화
            inputs.forEach(el => {
              if (el.dataset.orig !== undefined) el.value = el.dataset.orig;
              if (!el.name?.includes("productId") && !el.name?.includes("createdAt")) {
                if (el.tagName.toLowerCase() === "select") el.disabled = true;
                else el.readOnly = true;
              }
              // 옵션: 데이터 정리
              delete el.dataset.orig;
            });

            if (saveBtn) saveBtn.style.display = "none";
            btn.textContent = "수정";
          }
        };



    $(".addRow").click(function () {
      const $templateRow = $(".productAdd").first();
      const $newRow = $templateRow.clone(true);
      $newRow.removeClass("productAdd").removeAttr("style");
      $newRow.find("input").val("");

      // 유니크 폼 생성: 템플릿 복제 -> id만 교체
      const uid = Date.now();
      const formId = `addForm-${uid}`;
      const $newForm = $("#addForm-template").clone(true);
      $newForm.attr("id", formId);
      $("body").append($newForm); // CSRF 포함된 폼 추가

      // 행 안 모든 컨트롤에 form 속성 세팅
      $newRow.find("input, select, button").attr("form", formId);

      $("table tbody").prepend($newRow);
    });

    // 기존 + 신규 행 대분류 변경 시 중분류 자동 변경
    $(document).on("change", "select[name='parentCategoryId'], select[name='addParentCategoryId']", function () {
      const $row = $(this).closest("tr");
      const selectParentId = parseInt($(this).val());
      const $middleSelect = $row.find("select[name='middleCategoryId'], select[name='addMiddleCategoryId']");

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
