<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ include file="/WEB-INF/views/header.jsp" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>무인점포</title>
    <script src="${pageContext.request.contextPath}/static/js/jquery-3.7.1.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css" />
  </head>
  <body>
    <div class="containerAuto">
      <div class="title-box">
        <p class="sub-title">판매 모의</p>
        <h2 class="title">${storeName}</h2>
      </div>

      <div class="section-wrap">
        <form id="saleSave" action="saleOrder" method="post">
          <input type="hidden" name="today" value="${today}" />
          <div class="btn-box">
            <input type="submit" id="save-order" class="btn submit-btn" value="주문" />
          </div>
          <table class="orderSummary" aria-label="발주 요약">
            <tbody>
              <tr>
                <th class="vertical-label"><div>주문번호</div></th>
                <td name="saleId">${maxSaleId}</td>
                <th class="vertical-label"><div>주문일</div></th>
                <td name="today">${today}</td>
              </tr>
              <tr>
                <th class="vertical-label"><div>수량</div></th>
                <td>
                  <input type="text" id="sum-quantity" readonly value="0" />
                </td>
                <th class="vertical-label"><div>총금액</div></th>
                <td><input type="text" id="sum-total" readonly value="0" /></td>
              </tr>
            </tbody>
          </table>

          <!-- 성별 테이블 -->
          <table class="orderSummary" aria-label="성별, 나이">
            <tbody>
              <tr>
                <th class="vertical-label"><div>성별</div></th>
                <td>
                  <select id="genderSelect" name="gender" class="client-select" style="width:80%">
                    <option value="">성별을 선택하세요</option>
                    <option value="man">남자</option>
                    <option value="woman">여자</option>
                  </select>
                </td>
                <th class="vertical-label"><div>나이</div></th>
                <td>
                  <select name="age" id="ageSelect" style="width:80%">
                    <option value="">나이를 선택하세요</option>
                    <option value="10s">10대</option>
                    <option value="20s">20대</option>
                    <option value="30s">30대</option>
                    <option value="40s">40대</option>
                    <option value="atc">기타</option>
                  </select>
                </td>
              </tr>
            </tbody>
          </table>

          <div class="btn-box" style="margin: 20px">
            <button type="button" class="add-row btn btn-blue">행 추가</button>
            <button type="button" id="delete-selected" class="btn btn-red">선택 삭제</button>
          </div>

          <!-- 주문 상세 -->
          <table class="orderItems" aria-label="상세 상품 목록">
            <thead>
              <tr>
                <th><input type="checkbox" id="select-all" /></th>
                <th>상품명</th>
                <th>판매단가</th>
                <th>수량</th>
                <th>총 금액</th>
              </tr>
            </thead>
            <tbody>
              <tr class="item-row">
                <td class="checkbox-center">
                  <input type="checkbox" class="row-select" />
                </td>
                <td>
                  <select name="productName[]" class="product-select">
                    <option value="" selected disabled hidden>상품선택</option>
                    <c:forEach var="product" items="${products}">
                      <option value="${product.productName}">${product.productName}</option>
                    </c:forEach>
                  </select>
                </td>
                <td>
                  <span class="product-price"></span>
                </td>
                <td>
                  <input type="number" name="purchaseQty_display" class="count-input" min="0" />
                  <input type="hidden" name="purchaseQty[]" class="qty-hidden" />
                </td>
                <td>
                  <input type="text" name="total" class="total-display" readonly />
                </td>
              </tr>

              <tr class="item-row template" style="display: none">
                <td class="checkbox-center">
                  <input type="checkbox" class="row-select" />
                </td>
                <td>
                  <select class="product-select">
                    <option value="" selected disabled hidden>상품선택</option>
                    <c:forEach var="product" items="${products}">
                      <option value="${product.productName}">${product.productName}</option>
                    </c:forEach>
                  </select>
                </td>
                <td>
                  <span class="product-price"></span>
                </td>
                <td>
                  <input type="number" name="purchaseQty_display" class="count-input" min="0" />
                  <input type="hidden" class="qty-hidden" />
                </td>
                <td>
                  <input type="text" name="total" class="total-display" readonly />
                </td>
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
        // 행 추가 버튼 클릭 시 이벤트 리스너
        $('.add-row').on('click', function () {
          let $newRow = $('.template').clone().removeClass('template').show();

          // 복제된 새 행에 name 속성 추가
          $newRow.find('.product-select').attr('name', 'productName[]');
          $newRow.find('.qty-hidden').attr('name', 'purchaseQty[]');

          $newRow.find('input').val('');
          $('table.orderItems tbody').append($newRow);
          updateProductOptions();
          calcSummary();
        });

        // 선택 삭제 버튼 클릭 시 이벤트 리스너
        $('#delete-selected').on('click', function () {
          $('.item-row .row-select:checked').each(function () {
            $(this).closest('tr').remove();
          });
          updateProductOptions();
          calcSummary();
          $('#select-all').prop('checked', false);
        });

        // 전체 선택/해제
        $('#select-all').on('click', function () {
          $('.row-select').prop('checked', $(this).prop('checked'));
        });

        // 개별 체크박스 클릭 시 전체 선택 체크박스 상태 업데이트
        $(document).on('click', '.row-select', function () {
          let totalCheckboxes = $('.item-row:not(.template) .row-select').length;
          let checkedCheckboxes = $('.item-row:not(.template) .row-select:checked').length;
          $('#select-all').prop('checked', totalCheckboxes === checkedCheckboxes && totalCheckboxes > 0);
        });

        // 상품 선택 시 발생하는 이벤트 (AJAX 포함)
        $(document).on('change', '.product-select', function () {
          let selectedValue = $(this).val();
          let $currentRow = $(this).closest('tr');

          updateProductOptions();

          if (selectedValue) {
            $.ajax({
              url: '/sales/salePrice',
              type: 'post',
              data: { productName: selectedValue },
              success: function (data) {
                $currentRow.find('.product-price').text(data.toLocaleString());
                checkStockAndCalculate($currentRow);
              },
              error: function () {
                $currentRow.find('.product-price').text('0');
                $currentRow.find('.count-input').val("");
                calculateRowTotal($currentRow.find('.count-input'));
              },
            });
          } else {
            $currentRow.find('.product-price').text('0');
            $currentRow.find('.count-input').val("");
            calculateRowTotal($currentRow.find('.count-input'));
          }
        });

        // 수량 입력 시 총 금액 및 재고 업데이트
                $(document).on('keyup change', '.count-input', function () {
                    const $this = $(this);
                    const quantity = parseInt($this.val());

                    // 수정된 부분: 수량이 유효한 값(0 이상)일 때만 로직 실행
                    if (!isNaN(quantity) && quantity >= 0) {
                        checkStockAndCalculate($this.closest('tr'));
                    } else {
                        // 수량이 빈 값이나 유효하지 않은 값일 경우
                        $this.val('');
                        calculateRowTotal($this); // 총 금액을 초기화
                    }
                });

                // 재고 확인 및 총 금액 계산 함수
                function checkStockAndCalculate($row) {
                    let selectedProductName = $row.find('.product-select').val();
                    let enteredQuantity = parseInt($row.find('.count-input').val()) || 0;

                    if (selectedProductName && enteredQuantity > 0) {
                        $.ajax({
                            url: '/sales/getStock',
                            type: 'post',
                            data: { productName: selectedProductName },
                            success: function (availableStock) {
                                if (enteredQuantity > availableStock) {
                                    alert('재고가 부족합니다. 남은 재고: ' + availableStock + '개');
                                    $row.find('.count-input').val(availableStock);
                                    enteredQuantity = availableStock;
                                }
                                calculateRowTotal($row.find('.count-input'));
                            },
                            error: function () {
                                alert('재고 정보를 가져오는 데 실패했습니다.');
                                calculateRowTotal($row.find('.count-input'));
                            },
                        });
                    } else {
                        calculateRowTotal($row.find('.count-input'));
                    }
                }

                // 행별 총 금액 계산 함수
                function calculateRowTotal(quantityInput) {
                    let $row = quantityInput.closest('tr');
                    let priceText = $row.find('.product-price').text();
                    let price = priceText ? parseFloat(priceText.replace(/,/g, '')) : 0;
                    let quantity = parseInt(quantityInput.val());

                    // 수정된 부분: 수량이 NaN이거나 0보다 작을 경우 총 금액을 빈칸으로 설정
                    if (isNaN(quantity) || quantity < 0) {
                        $row.find('.total-display').val('');
                        $row.find('.qty-hidden').val('');
                    } else {
                        let total = price * quantity;
                        $row.find('.total-display').val(total.toLocaleString());
                        $row.find('.qty-hidden').val(quantity);
                    }
                    calcSummary();
                }

        // 전체 요약 (총 수량, 총 금액) 계산 함수
        function calcSummary() {
          let totalQuantity = 0;
          let grandTotal = 0;

          $('.item-row')
            .not('.template')
            .each(function () {
              let quantity = parseInt($(this).find('.qty-hidden').val()) || 0;
              let rowTotal = parseInt($(this).find('.total-display').val().replace(/,/g, '')) || 0;

              totalQuantity += quantity;
              grandTotal += rowTotal;
            });

          $('#sum-quantity').val(totalQuantity);
          $('#sum-total').val(grandTotal.toLocaleString());
        }

        function updateProductOptions() {
          let selectedProducts = $('.product-select')
            .map(function () {
              return $(this).val();
            })
            .get();

          $('.product-select option').each(function () {
            let optionValue = $(this).val();
            if (optionValue && selectedProducts.includes(optionValue)) {
              if ($(this).closest('select').val() !== optionValue) {
                $(this).prop('disabled', true);
              }
            } else {
              $(this).prop('disabled', false);
            }
          });
        }

        // 폼 제출 시 유효성 검사 (수정된 부분)
        $('#saleSave').on('submit', function (event) {
          let isValid = true;
          let errorMessages = [];

          // 성별 선택 확인 로직 추가
          const genderSelect = document.getElementById('genderSelect');
          if (genderSelect.value === '') {
            errorMessages.push('• 성별을 선택해주세요.');
            isValid = false;
          }

          // 나이 선택 확인 로직 추가
          const ageSelect = document.getElementById('ageSelect');
          if (ageSelect.value === '') {
            errorMessages.push('• 나이를 선택해주세요.');
            isValid = false;
          }

          // 템플릿 행은 제외하고 검사
          const activeRows = $('.item-row').not('.template');
          if (activeRows.length === 0) {
            errorMessages.push('• 주문할 상품을 한 개 이상 추가해주세요.');
            isValid = false;
          } else {
            activeRows.each(function (index) {
              const $row = $(this);
              const productName = $row.find('.product-select').val();
              const quantity = parseInt($row.find('.count-input').val()) || 0;

              if (!productName) {
                errorMessages.push('• ' + (index + 1) + '번째 행: 상품을 선택해주세요.');
                isValid = false;
              }
              if (quantity <= 0) {
                errorMessages.push('• ' + (index + 1) + '번째 행: 수량을 1개 이상 입력해주세요.');
                isValid = false;
              }
            });
          }

          if (!isValid) {
            alert('주문 오류:\n' + errorMessages.join('\n'));
            event.preventDefault(); // 폼 제출 중단
            return false;
          }
        });

        // 페이지 로드 시 초기 요약 계산 및 옵션 상태 업데이트
        calcSummary();
        updateProductOptions();
      });
    </script>
  </body>
</html>
