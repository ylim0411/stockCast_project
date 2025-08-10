<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ include file="/WEB-INF/views/header.jsp" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <title>발주서 수정</title>
    <script src="${pageContext.request.contextPath}/static/js/jquery-3.7.1.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css" />
  </head>
  <body>
    <div class="containerAuto">
      <div class="title-box">
        <p class="sub-title">발주 관리</p>
        <h2 class="title">발주서 수정</h2>
      </div>

      <div>
        <form id="orderUpdate" action="/order/orderUpdate" method="post">
          <!-- 숨겨진 필드 -->
          <input type="hidden" name="orderId" value="${orderInfo.orderId}" />
          <input
            type="hidden"
            name="orderDate"
            value="<fmt:formatDate value='${orderInfo.orderDate}' pattern='yyyy-MM-dd'/>"
          />
          <input type="hidden" name="clientId" value="${orderInfo.clientId}" />

          <!-- 저장 버튼 -->
          <div class="btn-box">
            <input type="submit" class="btn submit-btn" value="수정" />
          </div>

          <!-- 거래처 -->
          <table class="clientsName">
            <tr>
              <th class="vertical-label"><div>거래처명</div></th>
              <td><input type="text" value="${orderInfo.clientName}" readonly class="readonly-input" /></td>
            </tr>
          </table>

          <!-- 발주 요약 -->
          <table class="orderSummary">
            <tbody>
              <tr>
                <th class="vertical-label"><div>발주번호</div></th>
                <td>${orderInfo.orderId}</td>
                <th class="vertical-label"><div>발주등록일</div></th>
                <td><fmt:formatDate value="${orderInfo.orderDate}" pattern="yyyy-MM-dd" /></td>
              </tr>
              <tr>
                <th class="vertical-label"><div>수량</div></th>
                <td><input type="text" id="sum-quantity" readonly value="${orderInfo.totalCount}" /></td>
                <th class="vertical-label"><div>총금액</div></th>
                <td>
                  <input
                    type="text"
                    id="sum-total"
                    readonly
                    value="<fmt:formatNumber value='${orderInfo.totalPrice}'/>"
                  />
                </td>
              </tr>
            </tbody>
          </table>

          <!-- 행 추가/삭제 -->
          <div class="btn-box" style="margin: 20px">
            <button type="button" class="add-row btn btn-blue">행 추가</button>
            <button type="button" id="delete-selected" class="btn btn-red">선택 삭제</button>
          </div>

          <!-- 발주 상세 -->
          <table class="orderItems">
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
              <!-- 기존 발주 항목 -->
              <c:forEach var="item" items="${orderItems}">
                <tr
                  class="item-row"
                  data-top-id="${item.topCategoryId}"
                  data-sub-id="${item.subCategoryId}"
                  data-product-id="${item.productId}"
                >
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
                    <input
                      type="number"
                      name="purchasePrice_display"
                      class="price-input"
                      readonly
                      value="${item.purchasePrice}"
                    />
                    <input type="hidden" name="purchasePrice[]" class="price-hidden" value="${item.purchasePrice}" />
                  </td>
                  <td>
                    <input
                      type="number"
                      name="purchaseQty_display"
                      class="count-input"
                      min="0"
                      value="${item.purchaseQty}"
                    />
                    <input type="hidden" name="purchaseQty[]" class="qty-hidden" value="${item.purchaseQty}" />
                  </td>
                  <td>
                    <input
                      type="text"
                      name="total"
                      class="total-display"
                      readonly
                      value="<fmt:formatNumber value='${item.purchasePrice * item.purchaseQty}'/>"
                    />
                  </td>
                </tr>
              </c:forEach>

              <!-- 숨겨진 템플릿 -->
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
    </div>

    <script>
      $(document).ready(function () {
        const clientId = $('input[name="clientId"]').val();

        // 기존 발주 항목의 데이터 드롭다운 메뉴에 설정
        $('.item-row')
          .not('.template')
          .each(function () {
            const $row = $(this);
            const topId = $row.data('top-id');
            const subId = $row.data('sub-id');
            const productId = $row.data('product-id');

            loadTopCategories($row, clientId, topId, subId, productId);
          });

        // 폼 제출 시 유효성 검사
        $('#orderUpdate').submit(function (e) {
          if (!validateOrderItems(e)) {
            return false;
          }

          prepareFormData();
        });

        // 대분류 변경 시 중분류 로드 및 하위 항목 초기화
        $(document).on('change', '.top-category-select', function () {
          const $row = $(this).closest('tr');
          const parentId = $(this).val();

          resetCategorySelectors($row, 'sub');
          resetRowData($row);

          if (parentId) {
            loadSubCategories($row, clientId, parentId);
          }
        });

        // 중분류 변경 시 상품 로드 및 하위 항목 초기화
        $(document).on('change', '.sub-category-select', function () {
          const $row = $(this).closest('tr');
          const subId = $(this).val();

          resetCategorySelectors($row, 'item');
          resetRowData($row);

          if (subId) {
            loadProducts($row, subId);
          }
        });

        // 상품 선택 시 가격 반영 및 중복 체크
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

        // 행의 총 금액 전체 요약
        $(document).on('input', '.count-input', function () {
          calcRowTotal($(this).closest('tr'));
          calcSummary();
        });

        // 행 추가 버튼
        $('.add-row').click(function () {
          const $new = $('.template').clone().removeClass('template').show();
          $('table.orderItems tbody').append($new);

          resetAllRowData($new);
          loadTopCategories($new, clientId);
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

        // 전체 선택 체크박스 상태 변경 시, 모든 개별 체크박스 동기화
        $('#select-all').change(function () {
          $('.row-select').prop('checked', $(this).prop('checked'));
        });

        // 전체 선택 체크박스 상태 동기화
        $(document).on('change', '.row-select', function () {
          const allRows = $('.row-select').not('.template .row-select');
          const checkedRows = allRows.filter(':checked');
          $('#select-all').prop('checked', allRows.length === checkedRows.length);
        });

        // 발주 항목의 유효성 검사
        function validateOrderItems(e) {
          const items = $('.item-row').not('.template');

          if (items.length === 0) {
            alert('최소 1개 이상의 상품을 추가해야 합니다.');
            e.preventDefault();
            return false;
          }

          for (let i = 0; i < items.length; i++) {
            const $row = $(items[i]);
            const topCategory = $row.find('.top-category-select').val();
            const subCategory = $row.find('.sub-category-select').val();
            const productId = $row.find('.item-select').val();
            const qty = parseInt($row.find('.count-input').val(), 10);

            if (!topCategory || !subCategory || !productId) {
              alert('상품 정보가 누락된 행이 있습니다. 빈 행을 삭제하거나 상품을 선택하세요.');
              e.preventDefault();
              return false;
            }

            if (productId && (!qty || qty <= 0)) {
              alert('수량을 입력하거나 0보다 큰 값으로 수정하세요.');
              e.preventDefault();
              return false;
            }
          }

          return true;
        }

        // 서버 전송 전 데이터 정리
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

        // 특정 행의 상품 관련 데이터 초기화
        function resetRowData($row) {
          $row.find('.item-select').val('');
          $row.find('.price-input, .price-hidden').val('');
          $row.find('.count-input, .qty-hidden').val('');
          $row.find('.total-display').val('');
          calcSummary();
        }

        // 행의 모든 데이터 초기화
        function resetAllRowData($row) {
          $row.find('.row-select').prop('checked', false);
          $row.find('.top-category-select').empty().append('<option value="">대분류 선택</option>');
          $row.find('.sub-category-select').empty().append('<option value="">중분류 선택</option>');
          $row.find('.item-select').empty().append('<option value="">상품 선택</option>');
          $row.find('.price-input, .price-hidden').val('');
          $row.find('.count-input, .qty-hidden').val('');
          $row.find('.total-display').val('');
        }

        // 특정 행의 카테고리 선택자를 초기화하는 함수
        function resetCategorySelectors($row, type) {
          if (type === 'sub') {
            $row.find('.sub-category-select').empty().append('<option value="">중분류 선택</option>');
            $row.find('.item-select').empty().append('<option value="">상품 선택</option>');
          } else if (type === 'item') {
            $row.find('.item-select').empty().append('<option value="">상품 선택</option>');
          }
        }

        // 상품 중복 체크
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

        // 행별 총 금액 계산
        function calcRowTotal($row) {
          const price = parseFloat($row.find('.price-input').val()) || 0;
          const qty = parseInt($row.find('.count-input').val()) || 0;
          $row.find('.total-display').val((price * qty).toLocaleString('ko-KR'));
          $row.find('.qty-hidden').val(qty);
        }

        // 전체 요약 합계 계산
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

        // 드롭다운 메뉴를 채우는 통합 함수
        function fillSelect($select, list, defaultText, valueKey, textKey, priceKey, selectedVal) {
          if (list && list.length > 0) {
            list.forEach((item) => {
              let option = $('<option>')
                .val(item[valueKey])
                .text(item[textKey])
                .prop('selected', item[valueKey] == selectedVal);
              if (priceKey && item[priceKey] != null) option.attr('data-price', item[priceKey]);
              $select.append(option);
            });
          }
        }

        // 대분류 카테고리 로드 및 선택
        function loadTopCategories($row, clientId, topId = null, subId = null, productId = null) {
          $.get('/productCategory/top', { clientId }, function (data) {
            fillSelect(
              $row.find('.top-category-select'),
              data,
              '대분류 선택',
              'categoryId',
              'categoryName',
              null,
              topId
            );
            if (topId) loadSubCategories($row, clientId, topId, subId, productId);
          });
        }

        // 중분류 카테고리 로드 및 선택
        function loadSubCategories($row, clientId, topId, subId = null, productId = null) {
          $.get('/productCategory/sub', { parentId: topId, clientId }, function (data) {
            fillSelect(
              $row.find('.sub-category-select'),
              data,
              '중분류 선택',
              'categoryId',
              'categoryName',
              null,
              subId
            );
            if (subId) loadProducts($row, subId, productId);
          });
        }

        // 상품 목록 로드 및 선택
        function loadProducts($row, subId, productId = null) {
          $.get('/product/byCategory/' + subId, function (data) {
            fillSelect($row.find('.item-select'), data, '상품 선택', 'productId', 'productName', 'price', productId);
          });
        }
      });
    </script>
  </body>
</html>
