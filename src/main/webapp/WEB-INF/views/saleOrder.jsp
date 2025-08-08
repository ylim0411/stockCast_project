<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/header.jsp" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>모의점</title>
    <script src="${pageContext.request.contextPath}/static/js/jquery-3.7.1.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css"/>
</head>
<body>
<div class="containerAuto">
    <div class="title-box">
        <p class="sub-title">판매 모의</p>
        <h2 class="title">아이스크림 할인점</h2>
    </div>

 <div class="section-wrap">
        <form id="saleSave" action="#" method="post">
            <div class="btn-box">
            <input type="submit" id="save-order" class="btn submit-btn" value="작성">
            </div>
            <table class="orderSummary" aria-label="발주 요약">
                <tbody>
                <tr>
                    <th class="vertical-label"><div>주문번호</div></th>
                    <td><span id="order-number"></span></td>
                    <th class="vertical-label"><div>주문일</div></th>
                    <td><span id="order-date"></span></td>
                </tr>
                <tr>
                    <th class="vertical-label"><div>수량</div></th>
                    <td><input type="text" id="sum-quantity" readonly value="0"></td>
                    <th class="vertical-label"><div>총금액</div></th>
                    <td><input type="text" id="sum-total" readonly value="0"></td>
                </tr>
                </tbody>
            </table>

            <div class="btn-box" style="margin:20px;">
                <button type="button" class="add-row btn btn-blue">행 추가</button>
                <button type="button" id="delete-selected" class="btn btn-red">선택 삭제</button>
            </div>

            <!-- 주문 상세 -->
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
                <tr class="item-row template" style="display:none;">
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
      </div> <!-- section-wrap -->
</div> <!-- containerAuto -->

<script>
$(document).ready(function(){

    // 행 추가
    $('.add-row').click(function(){
        let $new = $('.template').clone().removeClass('template').show();
        $new.find('input').val('');
        $('table.orderItems tbody').append($new);
        // loadTopCategories($new); // 데이터 로드 로직 제거
    });

    // 선택 삭제
    $('#delete-selected').click(function(){
        $('.item-row .row-select:checked').not('#select-all').each(function(){
            $(this).closest('tr').remove();
        });
        // calcSummary(); // 합계 계산 로직 제거
    });

    // 전체 선택/해제
    $('#select-all').click(function(){
        $('.row-select').prop('checked', $(this).prop('checked'));
    });
});
</script>
</body>
</html>
