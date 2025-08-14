<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>전체 상품 목록</title>
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
      <form action="${pageContext.request.contextPath}/product/list" method="get">
        <div class="form-container">
          <div class="btn-box">
            <input type="text" name="productName" placeholder="상품명 검색" value="${param.productName}"/>
            <button type="submit" class="btn btn-blue">검색</button>
          </div>
          <button class="addRow btn submit-btn" type="button">상품 등록</button>
        </div>
      </form>

      <!-- 추가 등록용 템플릿 폼 -->
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
              <th>관리</th>
            </tr>
          </thead>
          <tbody>
          <c:forEach items="${not empty searchResult ? searchResult : categoryList}" var="row">
            <c:if test="${not empty searchResult}">
              <c:set var="p" value="${row}" />
              <tr data-product-id="${p.productId}">
                <td>
                  <select name="clientId" class="client-select" disabled>
                    <option value="">거래처를 선택하세요</option>
                    <c:forEach var="c" items="${clients}">
                      <option value="${c.clientId}" <c:if test="${c.clientId == p.clientId}">selected</c:if>>${c.clientName}</option>
                    </c:forEach>
                  </select>
                </td>
                <td>
                  <select name="parentCategoryId" class="parent-category-select" disabled>
                    <c:forEach items="${categoryList}" var="parentOption">
                      <c:if test="${parentOption.categoryLevel == 1}">
                        <option value="${parentOption.categoryId}" <c:if test="${parentOption.categoryId == p.parentCategoryId}">selected</c:if>>
                          ${parentOption.categoryName}
                        </option>
                      </c:if>
                    </c:forEach>
                  </select>
                </td>
                <td>
                  <select name="middleCategoryId" class="middle-category-select" disabled>
                    <c:forEach items="${categoryList}" var="parent">
                      <c:if test="${parent.categoryLevel == 1}">
                        <c:forEach items="${parent.categoryList}" var="m">
                          <option value="${m.categoryId}" <c:if test="${m.categoryId == p.middleCategoryId}">selected</c:if>>
                            ${m.categoryName}
                          </option>
                        </c:forEach>
                      </c:if>
                    </c:forEach>
                  </select>
                </td>
                <td><input type="text" name="productId" value="${p.productId}" readonly /></td>
                <td><input type="text" name="productName" value="${p.productName}" readonly /></td>
                <td><input type="number" name="price" value="${p.price}" readonly /></td>
                <td><input type="number" name="stockQuantity" value="${p.stockQuantity}" readonly /></td>
                <td><input type="text" name="createdAt" value="${p.createdAt != null ? fn:substring(p.createdAt,0,10) : ''}" readonly /></td>
                <td>
                  <form action="${pageContext.request.contextPath}/product/update" method="post" class="updateForm">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <button type="button" class="editBtn btn btn-blue">수정</button>
                    <button type="submit" class="saveBtn btn btn-blue" style="display:none;">저장</button>
                  </form>
                </td>
              </tr>
            </c:if>

            <c:if test="${empty searchResult}">
              <c:if test="${row.categoryLevel == 1}">
                <c:forEach items="${row.categoryList}" var="middle">
                  <c:if test="${middle.categoryLevel == 2}">
                    <c:forEach items="${middle.productList}" var="p">
                      <tr data-product-id="${p.productId}">
                        <td>
                          <select name="clientId" class="client-select" disabled>
                            <option value="">거래처를 선택하세요</option>
                            <c:forEach var="c" items="${clients}">
                              <option value="${c.clientId}" <c:if test="${c.clientId eq p.clientId}">selected</c:if>>
                                ${c.clientName}
                              </option>
                            </c:forEach>
                          </select>
                        </td>
                        <td>
                          <select name="parentCategoryId" class="parent-category-select" disabled>
                            <c:forEach items="${categoryList}" var="parentOption">
                              <c:if test="${parentOption.categoryLevel == 1}">
                                <option value="${parentOption.categoryId}" <c:if test="${parentOption.categoryId == middle.parentId}">selected</c:if>>
                                  ${parentOption.categoryName}
                                </option>
                              </c:if>
                            </c:forEach>
                          </select>
                        </td>
                        <td>
                          <select name="middleCategoryId" class="middle-category-select" disabled>
                            <c:forEach items="${row.categoryList}" var="m">
                              <option value="${m.categoryId}" <c:if test="${m.categoryId == middle.categoryId}">selected</c:if>>
                                ${m.categoryName}
                              </option>
                            </c:forEach>
                          </select>
                        </td>
                        <td><input type="text" name="productId" value="${p.productId}" readonly /></td>
                        <td><input type="text" name="productName" value="${p.productName}" readonly /></td>
                        <td><input type="number" name="price" value="${p.price}" readonly /></td>
                        <td><input type="number" name="stockQuantity" value="${p.stockQuantity}" readonly /></td>
                        <td><input type="text" name="createdAt" value="${p.createdAt != null ? fn:substring(p.createdAt,0,10) : ''}" readonly /></td>
                        <td>
                          <form action="${pageContext.request.contextPath}/product/update" method="post" class="updateForm">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <button type="button" class="editBtn btn btn-blue">수정</button>
                            <button type="submit" class="saveBtn btn btn-blue" style="display:none;">저장</button>
                          </form>
                        </td>
                      </tr>
                    </c:forEach>
                  </c:if>
                </c:forEach>
              </c:if>
            </c:if>
          </c:forEach>

          <!-- 추가행 템플릿 (숨김) -->
          <tr class="productAdd" style="display:none;">
            <td>
              <select name="clientId" form="addForm-template" class="client-select" required>
                <option value="">거래처를 선택하세요</option>
                <c:forEach var="c" items="${clients}">
                  <option value="${c.clientId}">${c.clientName}</option>
                </c:forEach>
              </select>
            </td>
            <td>
              <select name="parentCategoryId" form="addForm-template" class="parent-category-select" required>
                <option value="">대분류를 선택하세요.</option>
              </select>
            </td>
            <td>
              <!-- 컨트롤러가 addMiddleCategoryId 를 받으므로 name 일치 -->
              <select name="addMiddleCategoryId" form="addForm-template" class="middle-category-select" required>
                <option value="">중분류를 선택하세요.</option>
              </select>
            </td>
            <td><input type="text" name="addProductId" form="addForm-template" readonly /></td>
            <td><input type="text" name="addProductName" form="addForm-template" required /></td>
            <td><input type="number" name="addPrice" form="addForm-template" required /></td>
            <td><input type="number" name="addStockQuantity" form="addForm-template" required /></td>
            <td><input type="text" name="createdAt" form="addForm-template" readonly /></td>
            <td>
            <button type="submit" class="addBtn btn btn-blue" form="addForm-template">등록</button>
            <button type="button" class="cancelAdd btn btn-blue">취소</button>
            </td>
          </tr>

          </tbody>
        </table>
      </div>
    </div>
  </div>
</body>

<script>
$(document).ready(function () {
  // 거래처 선택 시 대분류 로드
  $(document).on('change', '.client-select', function() {
    const $row = $(this).closest('tr');
    const clientId = $(this).val();
    const $parent = $row.find('.parent-category-select');
    const $middle = $row.find('.middle-category-select');

    $parent.html('<option value="">대분류를 선택하세요.</option>');
    $middle.html('<option value="">중분류를 선택하세요.</option>');

    if (clientId) {
      $.get('${pageContext.request.contextPath}/productCategory/top', { clientId }, function(data) {
        data.forEach(function(cat) {
          $parent.append($('<option>', { value: cat.categoryId, text: cat.categoryName }));
        });
      });
    }
  });

  // 대분류 선택 시 중분류 로드
  $(document).on('change', '.parent-category-select', function() {
    const $row = $(this).closest('tr');
    const parentId = $(this).val();
    const clientId = $row.find('.client-select').val();
    const $middle = $row.find('.middle-category-select');

    $middle.html('<option value="">중분류를 선택하세요.</option>');

    if (parentId && clientId) {
      $.get('${pageContext.request.contextPath}/productCategory/sub', { parentId, clientId }, function(data) {
        data.forEach(function(cat) {
          $middle.append($('<option>', { value: cat.categoryId, text: cat.categoryName }));
        });
      });
    }
  });

  // 상품 등록 행 추가
  $(".addRow").click(function () {
    const $templateRow = $(".productAdd").first().clone(true);
    $templateRow.removeClass("productAdd").removeAttr("style");

    const uid = Date.now();
    const formId = `addForm-${uid}`;
    const $newForm = $("#addForm-template").clone(true);
    $newForm.attr("id", formId);
    $newForm.find('input[name="${_csrf.parameterName}"]').val('${_csrf.token}');
    $("body").append($newForm);

    $templateRow.attr("data-form-id", formId);
    $templateRow.find("input, select, button").attr("form", formId);
    $templateRow.find("input").val("");
    $templateRow.find(".client-select").val("");
    $templateRow.find(".parent-category-select, .middle-category-select")
               .empty().append('<option value="">선택하세요</option>');

    $("table tbody").prepend($templateRow);
  });

  $(document).on('click', '.cancelAdd', function() {
    const $row = $(this).closest('tr');
    const formId = $row.attr('data-form-id');
    if (formId) {
      $('#' + formId).remove();
    }
    $row.remove();
  });

  // 수정 버튼 토글
  $(document).on('click', '.editBtn', function() {
    const $row = $(this).closest('tr');
    const $form = $row.find('.updateForm');
    const formId = 'updateForm-' + $row.data('product-id');
    $form.attr('id', formId);

    const $inputs = $row.find('input[name], select[name]');
    const $saveBtn = $row.find('.saveBtn');
    const editing = $row.toggleClass('editing').hasClass('editing');

    if (editing) {
      $inputs.each(function () {
        const $el = $(this);
        const name = $el.attr('name');

        $el.data('orig', $el.val());

        if (!/^(productId|createdAt)$/.test(name)) {
          $el.prop('disabled', false).prop('readonly', false);
        }
        $el.attr('form', formId);
      });

      if ($form.find('input[type="hidden"][name="productId"]').length === 0) {
        $('<input>', {
          type:'hidden', name:'productId',
          value:$row.find('[name="productId"]').val()
        }).appendTo($form);
      }

      $saveBtn.show();
      $(this).text('취소');

    } else {
      $inputs.each(function () {
        const $el = $(this);
        const name = $el.attr('name');
        const orig = $el.data('orig');
        if (orig !== undefined) {
          $el.val(orig).removeData('orig');
        }
        if (!/^(productId|createdAt)$/.test(name)) {
          $el.prop('disabled', true).prop('readonly', true);
        }
        $el.removeAttr('form');
      });

      $form.find('input[type="hidden"][name]').each(function(){
        const n = this.name;
        if (['productId','clientId','middleCategoryId','productName','price','stockQuantity'].includes(n)) {
          $(this).remove();
        }
      });

      $saveBtn.hide();
      $(this).text('수정');
    }
  });

  $(document).on('submit', '.updateForm', function(e){
    const $form = $(this);
    const $row = $form.closest('tr');

    // 값 검증: 숫자 필드 공백 방지
    const $price = $row.find('[name="price"]');
    const $qty   = $row.find('[name="stockQuantity"]');
    const $name  = $row.find('[name="productName"]');
    const $client= $row.find('[name="clientId"]');
    const $mid   = $row.find('[name="middleCategoryId"]');

    // 공백/NaN 방지 (프론트에서 막아 400 예방)
    if (!$name.val() || $name.val().trim()==='') { alert('상품명을 입력해 주세요.'); e.preventDefault(); return false; }
    if (!$price.val() || isNaN($price.val())) { alert('상품가격을 입력해 주세요.'); e.preventDefault(); return false; }
    if (!$qty.val() || isNaN($qty.val())) { alert('재고수량을 입력해 주세요.'); e.preventDefault(); return false; }
    if (!$client.val()) { alert('거래처를 선택해 주세요.'); e.preventDefault(); return false; }
    if (!$mid.val()) { alert('중분류를 선택해 주세요.'); e.preventDefault(); return false; }

    // enable이면 hidden 제거, disabled면 hidden으로 값 보강
    ['clientId','middleCategoryId','productName','price','stockQuantity'].forEach(n=>{
      const $ctrl = $row.find(`[name="${n}"]`);
      const $hid  = $form.find(`input[type="hidden"][name="${n}"]`);
      if ($ctrl.length === 0) return;

      if ($ctrl.prop('disabled')) {
        if ($hid.length === 0) $('<input>', {type:'hidden', name:n}).appendTo($form);
        $form.find(`input[type="hidden"][name="${n}"]`).val($ctrl.val());
      } else {
        $hid.remove(); // 중복 제거
      }
    });

    // productId 값 보장
    let $pid = $form.find('input[type="hidden"][name="productId"]');
    const pidVal = $row.find('[name="productId"]').val();
    if ($pid.length === 0) {
      $('<input>', {type:'hidden', name:'productId', value: pidVal}).appendTo($form);
    } else {
      $pid.val(pidVal);
    }
  });

  // 초기 로드 시 선택값 유지하며 드롭다운 채우기
  $('.client-select').each(function() {
    const $row = $(this).closest('tr');
    const clientId = $(this).val();
    const parentId = $row.find('.parent-category-select').val();
    const middleId = $row.find('.middle-category-select').val();

    if (clientId) {
      $.get('${pageContext.request.contextPath}/productCategory/top', { clientId }, function(data) {
        const $parent = $row.find('.parent-category-select');
        $parent.empty().append('<option value="">대분류를 선택하세요.</option>');
        data.forEach(function(c) {
          $parent.append($('<option>', { value:c.categoryId, text:c.categoryName }));
        });
        $parent.val(parentId);
        if (parentId && middleId) {
          $.get('${pageContext.request.contextPath}/productCategory/sub', { parentId, clientId }, function(data) {
            const $middle = $row.find('.middle-category-select');
            $middle.empty().append('<option value="">중분류를 선택하세요.</option>');
            data.forEach(function(c) {
              $middle.append($('<option>', { value:c.categoryId, text:c.categoryName }));
            });
            $middle.val(middleId);
          });
        }
      });
    }
  });
});
</script>
</html>
