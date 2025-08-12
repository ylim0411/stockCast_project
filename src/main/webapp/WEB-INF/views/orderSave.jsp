<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ include file="/WEB-INF/views/header.jsp" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>발주서 작성</title>
    <script src="${pageContext.request.contextPath}/static/js/jquery-3.7.1.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css" />
  </head>
  <body>
    <div class="containerAuto">
      <div class="title-box">
        <p class="sub-title">발주 관리</p>
        <h2 class="title">발주서 작성</h2>
      </div>

      <div class="section-wrap">
        <form id="orderSave" action="/order/orderSave" method="post">
          <!-- 숨겨진 필드 -->
          <input type="hidden" name="orderSubnum" id="orderIdHidden" />
          <input type="hidden" name="order_Id" id="order_IdHidden" />
          <input type="hidden" name="orderDate" id="orderDateHidden" />

          <!-- 저장 -->
          <div class="btn-box">
            <input type="submit" id="save-order" class="btn submit-btn" value="작성완료" style="font-size:14px !important;"/>
          </div>

          <!-- 거래처 -->
          <table class="clientsName">
            <tr>
              <th class="vertical-label"><div>거래처명</div></th>
              <td>
                <select id="clientSelect" name="clientId" class="client-select">
                  <option value="">거래처를 선택하세요</option>
                  <c:forEach var="c" items="${clients}">
                    <option value="${c.clientId}">${c.clientName}</option>
                  </c:forEach>
                </select>
              </td>
            </tr>
          </table>

          <!-- 발주 요약 -->
          <table class="orderSummary" aria-label="발주 요약">
            <tbody>
              <tr>
                <th class="vertical-label"><div>발주번호</div></th>
                <td><span id="order-number"></span></td>
                <th class="vertical-label"><div>발주등록일</div></th>
                <td><span id="order-date"></span></td>
              </tr>
              <tr>
                <th class="vertical-label"><div>수량</div></th>
                <td><input type="text" id="sum-quantity" readonly value="0" /></td>
                <th class="vertical-label"><div>총금액</div></th>
                <td><input type="text" id="sum-total" readonly value="0" /></td>
              </tr>
            </tbody>
          </table>

          <div class="btn-box" style="margin: 20px">
            <button type="button" class="add-row btn btn-blue">행 추가</button>
            <button type="button" id="delete-selected" class="btn btn-red">선택 삭제</button>
          </div>

          <!-- 발주 상세 -->
          <table class="orderItems" aria-label="상세 상품 목록">
            <thead>
              <tr>
                <th><input type="checkbox" id="select-all" /></th>
                <th>대분류</th>
                <th>중분류</th>
                <th>상품명</th>
                <th>구매단가</th>
                <th>수량</th>
                <th>총 금액</th>
              </tr>
            </thead>
            <tbody>
              <!-- 기본 행 -->
              <tr class="item-row">
                <td class="checkbox-center"><input type="checkbox" class="row-select" /></td>
                <td>
                  <select class="top-category-select">
                    <option value="">대분류 선택</option>
                  </select>
                </td>
                <td>
                  <select class="sub-category-select">
                    <option value="">중분류 선택</option>
                  </select>
                </td>
                <td>
                  <select name="productId[]" class="item-select">
                    <option value="">상품 선택</option>
                  </select>
                </td>
                <td>
                  <input type="number" name="purchasePrice_display" class="price-input" readonly />
                  <input type="hidden" name="purchasePrice[]" class="price-hidden" />
                </td>
                <td>
                  <input type="number" name="purchaseQty_display" class="count-input" min="0" />
                  <input type="hidden" name="purchaseQty[]" class="qty-hidden" />
                </td>
                <td><input type="text" name="total" class="total-display" readonly /></td>
              </tr>

              <!-- 숨겨진 템플릿 행 -->
              <tr class="item-row template" style="display: none">
                <td class="checkbox-center"><input type="checkbox" class="row-select" /></td>
                <td>
                  <select class="top-category-select">
                    <option value="">대분류 선택</option>
                  </select>
                </td>
                <td>
                  <select class="sub-category-select">
                    <option value="">중분류 선택</option>
                  </select>
                </td>
                <td>
                  <select name="productId[]" class="item-select">
                    <option value="">상품 선택</option>
                  </select>
                </td>
                <td>
                  <input type="number" name="purchasePrice_display" class="price-input" readonly />
                  <input type="hidden" name="purchasePrice[]" class="price-hidden" />
                </td>
                <td>
                  <input type="number" name="purchaseQty_display" class="count-input" min="0" />
                  <input type="hidden" name="purchaseQty[]" class="qty-hidden" />
                </td>
                <td><input type="text" name="total" class="total-display" readonly /></td>
              </tr>
            </tbody>
          </table>
        </form>
      </div>
      <!-- section-wrap -->
    </div>
    <!-- containerAuto -->

    <script>
      $(document).ready(function () {
        // 새로운 발주 번호와 등록일자 화면에 표시
        $.get('/order/new-info', function (data) {
          $('#order-number').text(data.orderNumber);
          $('#order-date').text(data.orderDate);
          $('#orderIdHidden').val(data.orderNumber);
          $('#order_IdHidden').val(data.order_Id);
          $('#orderDateHidden').val(data.orderDate);
        });

        // 폼 제출 시 유효성 검사
        $('#orderSave').on('submit', function (e) {
          let clientId = $('#clientSelect').val();
          if (!clientId) {
            alert('거래처를 선택하세요.');
            e.preventDefault();
            return false;
          }

          if (!validateOrderItems(e)) {
            return false;
          }

          prepareFormData();
        });

        // 모든 행의 대분류 카테고리 다시 로드 및 하위 항목 초기화
        $(document).on('change', '#clientSelect', function () {
          const clientId = $(this).val();
          if (clientId) {
            $('.item-row')
              .not('.template')
              .each(function () {
                resetAllItemRow($(this));
                loadTopCategories($(this), clientId);
              });
          } else {
            $('.item-row')
              .not('.template')
              .each(function () {
                resetAllItemRow($(this));
              });
          }
          calcSummary();
        });

        // 대분류 변경 시 중분류 로드 및 하위 항목 초기화
        $(document).on('change', '.top-category-select', function () {
          const $row = $(this).closest('tr');
          const clientId = $('#clientSelect').val();
          const parentId = $(this).val();

          // 중분류, 상품명, 가격, 수량, 총금액 초기화
          resetSubCategorySelectors($row);
          resetRowData($row);

          if (parentId) {
            loadSubCategories($row, clientId, parentId);
          }
        });

        // 중분류 변경 시 상품 로드 및 하위 항목 초기화
        $(document).on('change', '.sub-category-select', function () {
          const $row = $(this).closest('tr');
          const subId = $(this).val();

          // 상품명, 가격, 수량, 총금액 초기화
          resetProductSelectors($row);
          resetRowData($row);

          if (subId) {
            loadProducts($row, subId);
          }
        });

        // 상품 선택 시 가격 자동 반영 및 중복 체크
        $(document).on('change', '.item-select', function () {
          const $row = $(this).closest('tr');
          const productId = $(this).val();

          if (!productId) {
            resetRowData($row);
            return;
          }

          if (isProductDuplicate(productId, this)) {
            alert('이미 선택한 상품입니다.');
            resetRowData($row);
            return;
          }

          const price = $(this).find(':selected').data('price') || 0;
          $row.find('.price-input, .price-hidden').val(price);

          calcRowTotal($row);
          calcSummary();
        });

        // 행의 총 금액과 전체 합계 계산
        $(document).on('input', '.count-input', function () {
          calcRowTotal($(this).closest('tr'));
          calcSummary();
        });

        // 행 추가 버튼
        $('.add-row').click(function () {
          const $new = $('.template').clone().removeClass('template').show();
          resetAllItemRow($new);
          $('table.orderItems tbody').append($new);

          const clientId = $('#clientSelect').val();
          if (clientId) {
            loadTopCategories($new, clientId); 
          }

          $('#select-all').prop('checked', false);
        });

        // 선택 삭제 버튼
        $('#delete-selected').click(function () {
          const selectedRows = $('.row-select:checked');
          if (selectedRows.length === 0) {
            alert('삭제할 항목을 선택해주세요.');
            return;
          }

          if (confirm('선택된 항목을 삭제하시겠습니까?')) {
            selectedRows.closest('tr').not('.template').remove();
            calcSummary();
            $('#select-all').prop('checked', false);
          }
        });

        // 모든 개별 체크박스 상태 동기화
        $('#select-all').change(function () {
          $('.row-select').prop('checked', $(this).prop('checked'));
        });

        // 전체 선택 체크박스 상태 동기화
        $(document).on('change', '.row-select', function () {
          const allRows = $('.row-select').not('.template .row-select');
          const checkedRows = allRows.filter(':checked');
          $('#select-all').prop('checked', allRows.length === checkedRows.length);
        });

        // 유효성 검사
        function validateOrderItems(e) {
          let hasProduct = false;
          let hasInvalidQty = false;
          let hasEmptyRow = false;
          const items = $('.item-row').not('.template');

          // 최소 1개 이상의 행이 존재하는지 검사
          if (items.length === 0) {
            alert('최소 1개 이상의 상품을 추가해야 합니다.');
            e.preventDefault();
            return false;
          }

          items.each(function () {
            const topCategory = $(this).find('.top-category-select').val();
            const subCategory = $(this).find('.sub-category-select').val();
            const productId = $(this).find('.item-select').val();
            const qty = parseInt($(this).find('.count-input').val(), 10);

            // 상품 정보가 누락된 행(대분류, 중분류, 상품명 중 하나라도 비어있는 경우)
            if (!topCategory || !subCategory || !productId) {
              hasEmptyRow = true;
              return false;
            }

            // 상품은 선택되었으나 수량이 유효하지 않은 경우
            if (productId && (!qty || qty <= 0)) {
              hasInvalidQty = true;
              return false;
            }

            if (productId && qty > 0) {
              hasProduct = true;
            }
          });

          if (hasEmptyRow) {
            alert('상품 정보가 누락된 행이 있습니다. 빈 행을 삭제하거나 상품을 선택하세요.');
            e.preventDefault();
            return false;
          }

          if (hasInvalidQty) {
            alert('수량을 입력하거나 0보다 큰 값으로 수정하세요.');
            e.preventDefault();
            return false;
          }

          // 유효한 항목이 하나도 없을 경우
          if (!hasProduct) {
            alert('최소 1개 이상의 상품을 선택하고 수량을 입력하세요.');
            e.preventDefault();
            return false;
          }

          return true;
        }

        // 서버 전송 데이터를 정리
        function prepareFormData() {
          $('.item-row')
            .not('.template')
            .each(function () {
              const productId = $(this).find('.item-select').val();

              if (!productId) {
                $(this).find('input, select').removeAttr('name');
              }

              const price = $(this).find('.price-input').val();
              const qty = $(this).find('.count-input').val();
              $(this)
                .find('.price-hidden')
                .val(price || 0);
              $(this)
                .find('.qty-hidden')
                .val(qty || 0);
            });
        }

        // 특정 행의 중분류, 상품 select 초기화
        function resetSubCategorySelectors($row) {
          $row.find('.sub-category-select').html('<option value="">중분류 선택</option>');
          $row.find('.item-select').html('<option value="">상품 선택</option>');
        }

        // 특정 행의 상품 select 초기화
        function resetProductSelectors($row) {
          $row.find('.item-select').html('<option value="">상품 선택</option>');
        }

        // 특정 행의 상품 관련 데이터(가격, 수량, 총액) 초기화
        function resetRowData($row) {
          $row.find('.item-select').val('');
          $row.find('.price-input, .price-hidden').val('');
          $row.find('.count-input, .qty-hidden').val('');
          $row.find('.total-display').val('');
          calcSummary(); // 초기화 후 전체 요약 재계산
        }

        // 특정 행의 모든 입력 필드 및 선택자 초기화
        function resetAllItemRow($row) {
          $row.find('.top-category-select').empty().append('<option value="">대분류 선택</option>');
          resetSubCategorySelectors($row);
          resetRowData($row);
        }

        // 선택된 상품이 이미 목록에 있는지 확인
        function isProductDuplicate(productId, currentElement) {
          let duplicate = false;
          $('.item-select')
            .not(currentElement)
            .each(function () {
              if ($(this).val() === productId) {
                duplicate = true;
                return false;
              }
            });
          return duplicate;
        }

        // 특정 행의 구매 총 금액을 계산
        function calcRowTotal($row) {
          const price = parseFloat($row.find('.price-input').val()) || 0;
          const count = parseInt($row.find('.count-input').val()) || 0;
          const total = price * count;

          $row.find('.total-display').val(total.toLocaleString('ko-KR'));
          $row.find('.qty-hidden').val(count);
        }

        // 모든 행의 총 수량과 총 금액을 계산
        function calcSummary() {
          let totalQty = 0,
            totalAmt = 0;
          $('.item-row')
            .not('.template')
            .each(function () {
              totalQty += parseInt($(this).find('.count-input').val()) || 0;
              totalAmt += parseFloat(($(this).find('.total-display').val() || '0').replace(/,/g, '')) || 0;
            });
          $('#sum-quantity').val(totalQty);
          $('#sum-total').val(totalAmt.toLocaleString('ko-KR'));
        }

        // 대분류 카테고리 목록을 가져와 특정 행의 select에 채움
        function loadTopCategories($row, clientId) {
          $.get('/productCategory/top', { clientId }, function (data) {
            let $top = $row.find('.top-category-select').empty().append('<option value="">대분류 선택</option>');
            data.forEach((c) => $top.append('<option value="' + c.categoryId + '">' + c.categoryName + '</option>'));
          });
        }

        // 중분류 카테고리 목록을 가져와 특정 행의 select에 채움
        function loadSubCategories($row, clientId, parentId) {
          $.get('/productCategory/sub', { parentId, clientId }, function (data) {
            let $sub = $row.find('.sub-category-select').empty().append('<option value="">중분류 선택</option>');
            data.forEach((c) => $sub.append('<option value="' + c.categoryId + '">' + c.categoryName + '</option>'));
          });
        }

        // 상품 목록을 가져와 특정 행의 select에 채움
        function loadProducts($row, subId) {
          $.get('/product/byCategory/' + subId, function (data) {
            let $prod = $row.find('.item-select').empty().append('<option value="">상품 선택</option>');
            data.forEach((p) =>
              $prod.append(
                '<option value="' + p.productId + '" data-price="' + p.price + '">' + p.productName + '</option>'
              )
            );
          });
        }
      });
    </script>
  </body>
</html>
