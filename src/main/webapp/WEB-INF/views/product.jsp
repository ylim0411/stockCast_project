<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html><html lang="en"><head>
  <meta charset="UTF-8">
  <title>index</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css"/></head><body>
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
      <table class="productTable product-table">
        <thead>
          <tr>
            <th>거래처선택</th>
            <th>대분류</th>
            <th>중분류</th>
            <th>상품코드</th>
            <th>상품명</th>
            <th>상품가격</th>
            <th>재고수량</th>
            <th>등록일자</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          <c:if test="${not empty searchResult}">
            <c:forEach items="${searchResult}" var="product">
              <tr data-product-id="${product.productId}">
                <form method="post" action="${pageContext.request.contextPath}/product/update">
                  <td>
                    <select name="clientId" class="client-select" disabled>
                      <option value="">거래처를 선택하세요</option>
                      <c:forEach var="c" items="${clients}">
                        <option value="${c.clientId}" <c:if test="${c.clientId == product.clientId}">selected</c:if>>${c.clientName}</option>
                      </c:forEach>
                    </select>
                  </td>
                  <td colspan="2">
                    <select name="parentCategoryId" class="parent-category-select" disabled>
                      <c:forEach items="${categoryList}" var="parentOption">
                        <c:if test="${parentOption.categoryLevel == 1}">
                          <option value="${parentOption.categoryId}"
                            <c:if test="${parentOption.categoryId == product.parentCategoryId}">selected</c:if>>
                            ${parentOption.categoryName}
                          </option>
                        </c:if>
                      </c:forEach>
                    </select>
                    <select name="middleCategoryId" class="middle-category-select" disabled>
                      <c:forEach items="${categoryList}" var="parent">
                        <c:if test="${parent.categoryLevel == 1}">
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
              <c:if test="${parent.categoryLevel == 1}">
                <c:forEach items="${parent.categoryList}" var="middle">
                  <c:if test="${middle.categoryLevel == 2}">
                    <c:forEach items="${middle.productList}" var="product">
                      <tr data-product-id="${product.productId}">
                        <form method="post" action="${pageContext.request.contextPath}/product/update">
                          <td>
                            <select name="clientId" class="client-select" disabled>
                              <option value="">거래처를 선택하세요</option>
                              <c:forEach var="c" items="${clients}">
                                <option value="${c.clientId}" <c:if test="${c.clientId == product.clientId}">selected</c:if>>${c.clientName}</option>
                              </c:forEach>
                            </select>
                          </td>
                          <td>
                            <select name="parentCategoryId" class="parent-category-select" disabled>
                              <c:forEach items="${categoryList}" var="parentOption">
                                <c:if test="${parentOption.categoryLevel == 1}">
                                  <option value="${parentOption.categoryId}"
                                    <c:if test="${parentOption.categoryId == middle.parentId}">selected</c:if>>
                                    ${parentOption.categoryName}
                                  </option>
                                </c:if>
                              </c:forEach>
                            </select>
                          </td>
                          <td>
                            <select name="middleCategoryId" class="middle-category-select" disabled>
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
                          <td><input type="number" name="price" value="${product.price}" readonly /></td>
                          <td><input type="number" name="stockQuantity" value="${product.stockQuantity}" readonly /></td>
                          <td>
                            <input type="text" name="createdAt"
                                   value="${product.createdAt != null ? fn:substring(product.createdAt, 0, 10) : ''}"
                                   readonly />
                           </td>
                          <td>
                          <button type="button" onclick="updateFn(this)">수정</button>
                          <button type="submit" class="saveBtn" style="display:none;">저장</button>
                          </td>
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
              <select name="clientId" form="addForm-template" class="client-select" required>
                <option value="">거래처를 선택하세요</option>
                <c:forEach var="c" items="${clients}">
                  <option value="${c.clientId}">${c.clientName}</option>
                </c:forEach>
              </select>
            </td>
            <td class="parent-category-cell">
              <select name="addParentCategoryId" form="addForm-template" class="parent-category-select" required>
                <option value="">대분류를 선택하세요.</option>
              </select>
            </td>
            <td class="middle-category-cell">
              <select name="addMiddleCategoryId" form="addForm-template" class="middle-category-select" required>
                <option value="">중분류를 선택하세요.</option>
              </select>
            </td>
            <td><input type="text" name="addProductId" form="addForm-template" readonly /></td>
            <td><input type="text" name="addProductName" form="addForm-template" required /></td>
            <td><input type="number" name="addPrice" form="addForm-template" required /></td>
            <td><input type="number" name="addStockQuantity" form="addForm-template" required /></td>
            <td><input type="text" name="createdAt" form="addForm-template" readonly /></td>
            <td><button type="submit" class="addBtn" form="addForm-template">등록</button></td>
          </tr>
        </tbody>
      </table>
      </div>
    </div>
  </div></body><script>
  $(document).ready(function () {

    // 거래처 선택 시 대분류 카테고리 로드
    $(document).on('change', '.client-select', function() {
      const $row = $(this).closest('tr');
      const clientId = $(this).val();
      const $parentCategorySelect = $row.find('.parent-category-select');
      const $middleCategorySelect = $row.find('.middle-category-select');

      // 대분류, 중분류 셀렉트 박스 초기화
      $parentCategorySelect.html('<option value="">대분류를 선택하세요.</option>');
      $middleCategorySelect.html('<option value="">중분류를 선택하세요.</option>');

      if (clientId) {
        // 거래처 선택 시에만 대분류 카테고리 로드
        $.get('${pageContext.request.contextPath}/productCategory/top', { clientId: clientId }, function(data) {
          data.forEach(function(category) {
            $parentCategorySelect.append($('<option>', {
              value: category.categoryId,
              text: category.categoryName
            }));
          });
        });
      }
    });

    // 대분류 카테고리 선택 시 중분류 카테고리 로드
    $(document).on('change', '.parent-category-select', function() {
      const $row = $(this).closest('tr');
      const parentId = $(this).val();
      const clientId = $row.find('.client-select').val();
      const $middleCategorySelect = $row.find('.middle-category-select');

      // 중분류 셀렉트 박스 초기화
      $middleCategorySelect.html('<option value="">중분류를 선택하세요.</option>');

      if (parentId && clientId) {
        // 대분류와 거래처가 모두 선택되었을 때만 중분류 카테고리 로드
        $.get('${pageContext.request.contextPath}/productCategory/sub', { parentId: parentId, clientId: clientId }, function(data) {
          data.forEach(function(category) {
            $middleCategorySelect.append($('<option>', {
              value: category.categoryId,
              text: category.categoryName
            }));
          });
        });
      }
    });

    // 상품 등록 버튼 클릭 시
    $(".addRow").click(function () {
      const $templateRow = $(".productAdd").first().clone(true);
      $templateRow.removeClass("productAdd").removeAttr("style");

      // 동적으로 생성된 행이므로 클래스 선택자를 사용해 폼 ID를 동적으로 할당
      const uid = Date.now();
      const formId = `addForm-${uid}`;
      const $newForm = $("#addForm-template").clone(true);
      $newForm.attr("id", formId);
      $newForm.find('input[name="_csrf"]').attr('value', '${_csrf.token}');
      $("body").append($newForm);
      $templateRow.find("input, select, button").attr("form", formId);
      $templateRow.find("input").val("");
      $templateRow.find(".client-select").val(""); // 거래처 셀렉트 초기화
      $templateRow.find(".parent-category-select, .middle-category-select").empty().append('<option value="">선택하세요</option>'); // 카테고리 셀렉트 초기화

      $("table tbody").prepend($templateRow);
    });

    // 수정 버튼 클릭 시
    window.updateFn = (btn) => {
      const row = $(btn).closest("tr");
      const inputs = row.find("input, select");
      const saveBtn = row.find(".saveBtn");
      const isEditing = row.hasClass("editing");

      row.toggleClass("editing");

      if (!isEditing) { // 수정 모드로 진입
        inputs.each(function() {
          const el = $(this);
          const tag = el.prop('tagName').toLowerCase();
          if (tag === "select" || ["text", "number"].includes(el.attr('type'))) {
            el.data('orig', el.val());
          }
          if (!el.attr('name')?.includes("productId") && !el.attr('name')?.includes("createdAt")) {
            el.prop('disabled', false);
            el.prop('readonly', false);
          }
        });
        saveBtn.show();
        $(btn).text("취소");
      } else { // 취소 버튼 클릭
        inputs.each(function() {
          const el = $(this);
          if (el.data('orig') !== undefined) {
            el.val(el.data('orig'));
            el.removeData('orig');
          }
          if (!el.attr('name')?.includes("productId") && !el.attr('name')?.includes("createdAt")) {
            el.prop('disabled', true);
            el.prop('readonly', true);
          }
        });
        saveBtn.hide();
        $(btn).text("수정");
      }
    };

    // 초기 로드 시 기존 항목의 카테고리 드롭다운도 동적 로딩 기능 적용 (선택된 값 유지)
    $('.client-select').each(function() {
      const $row = $(this).closest('tr');
      const clientId = $(this).val();
      const parentId = $row.find('.parent-category-select').val();
      const middleId = $row.find('.middle-category-select').val();

      if (clientId) {
          // 대분류 로드
          $.get('${pageContext.request.contextPath}/productCategory/top', { clientId: clientId }, function(data) {
              const $parentSelect = $row.find('.parent-category-select');
              $parentSelect.empty().append('<option value="">대분류를 선택하세요.</option>');
              data.forEach(function(c) {
                  $parentSelect.append($('<option>', {
                      value: c.categoryId,
                      text: c.categoryName
                  }));
              });
              $parentSelect.val(parentId); // 기존 값 선택
              if (parentId && middleId) {
                // 중분류 로드
                $.get('${pageContext.request.contextPath}/productCategory/sub', { parentId: parentId, clientId: clientId }, function(data) {
                    const $middleSelect = $row.find('.middle-category-select');
                    $middleSelect.empty().append('<option value="">중분류를 선택하세요.</option>');
                    data.forEach(function(c) {
                        $middleSelect.append($('<option>', {
                            value: c.categoryId,
                            text: c.categoryName
                        }));
                    });
                    $middleSelect.val(middleId); // 기존 값 선택
                });
              }
          });
      }
    });

  });</script></html>