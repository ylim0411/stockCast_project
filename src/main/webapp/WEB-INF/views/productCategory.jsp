<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ include file="/WEB-INF/views/header.jsp" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> <%@ taglib prefix="fn"
uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>index</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/modal.css" />
    <style>
      .hidden {
        display: none;
      }

      .arrow {
        display: inline-block;
        transition: transform 0.3s ease;
      }

      .arrow.rotate {
        transform: rotate(90deg); /* 오른쪽 화살표 -> 아래로 */
      }

      .arrow.rotate-up {
        transform: rotate(-90deg); /* 오른쪽 화살표 -> 위로 */
      }
    </style>
  </head>
  <body>
    <div id="productCategory" class="containerAuto">
      <div class="title-box">
        <p class="sub-title">상품 관리</p>
        <h2 class="title">상품 카테고리</h2>
      </div>
      <div class="section-wrap">
        <!-- 카테고리 등록 버튼 -->
        <div class="form-container">
          <div class="btn-box">
            <button id="middle" class="btn btn-blue" style="display: flex; gap: 10px; align-items: center">
              중분류 <span class="arrow rotate">&#8250;</span>
            </button>
            <button id="child" class="btn btn-blue" style="display: flex; gap: 10px; align-items: center">
              소분류 <span class="arrow rotate">&#8250;</span>
            </button>
          </div>
          <button class="btn btn-blue-b">카테고리 등록</button>
        </div>

        <c:set var="prevTop" value="" />
        <c:set var="prevMiddle" value="" />

        <table class="productCategory-table">
          <thead>
            <tr>
              <th>카테고리 레벨</th>
              <th>카테고리/상품명</th>
              <th>카테고리 등록일자</th>
            </tr>
          </thead>
          <tbody>
            <c:set var="prevTop" value="" />
            <c:set var="prevMiddle" value="" />

            <c:forEach items="${categoryList}" var="item">

              <c:set var="topName" value="${item.topLevelCategoryName != null ? item.topLevelCategoryName : ''}" />
              <c:set var="midName" value="${item.categoryName != null ? item.categoryName : ''}" />
              <c:set var="catDate" value="${item.categoryCreatedAt}" />
              <c:set var="prodName" value="${item.productName != null ? item.productName : ''}" />
              <c:set var="prodDate" value="${item.productCreatedAt}" />

              <%-- 대분류 값이 있을 때만 한 번 렌더링 --%>
              <c:if test="${not empty topName and prevTop != topName}">
                <tr class="parentLevel" data-id="${topName}">
                  <td>대분류</td>
                  <td>${topName}</td>
                  <td>
                    <c:if test="${not empty catDate}"> ${fn:substring(catDate, 0, 10)} </c:if>
                  </td>
                </tr>
                <c:set var="prevTop" value="${topName}" />
                <c:set var="prevMiddle" value="" />
              </c:if>

              <%-- 중분류 값이 있을 때만 렌더링 --%>
              <c:if test="${not empty midName and prevMiddle != midName}">
                <tr class="middleLevel" data-id="${midName}" data-parent="${topName}">
                  <td>중분류</td>
                  <td>${midName}</td>
                  <td>
                    <c:if test="${not empty catDate}"> ${fn:substring(catDate, 0, 10)} </c:if>
                  </td>
                </tr>
                <c:set var="prevMiddle" value="${midName}" />
              </c:if>

              <%-- 소분류 값이 있을 때만 렌더링 --%>
              <c:if test="${not empty prodName}">
                <tr class="childLevel" data-parent="${midName}">
                  <td>소분류</td>
                  <td>${prodName}</td>
                  <td>
                    <c:if test="${not empty prodDate}"> ${fn:substring(prodDate, 0, 10)} </c:if>
                  </td>
                </tr>
              </c:if>
            </c:forEach>
          </tbody>
        </table>

        <!-- 카테고리 등록 모달 -->
        <div id="categoryModal" class="modal hidden">
          <!-- 공통 modal-content는 유지 + 고유 클래스 cat-modal 추가 -->
          <div class="modal-content cat-modal">
            <!-- 상단 타이틀 / 닫기 -->
            <div class="cat-modal__title">
              <h2>상품 카테고리 편집</h2>
              <button type="button" class="cat-modal__close" id="closeModal">×</button>
            </div>

            <div class="cat-modal__columns">
              <!-- 대분류 -->
              <section class="cat-panel">
                <div class="cat-panel__head">
                  <span>대분류</span>
                  <span class="cat-panel__count">(<span id="topCount">0</span>)</span>
                </div>
                <ul id="topCategoryList" class="category-list cat-panel__list"></ul>
                <input
                  type="text"
                  id="topInput"
                  class="category-input cat-panel__input"
                  placeholder="+ Enter키로 대분류 추가"
                />
              </section>

              <!-- 중분류 -->
              <section class="cat-panel">
                <div class="cat-panel__head">
                  <span>중분류</span>
                  <span class="cat-panel__count">(<span id="middleCount">0</span>)</span>
                </div>
                <ul id="middleCategoryList" class="category-list cat-panel__list"></ul>
                <input
                  type="text"
                  id="middleInput"
                  class="category-input cat-panel__input"
                  placeholder="+ Enter키로 중분류 추가"
                  disabled
                />
              </section>

              <!-- 소분류 -->
              <section class="cat-panel">
                <div class="cat-panel__head">
                  <span>소분류</span>
                  <span class="cat-panel__count">(<span id="childCount">0</span>)</span>
                </div>
                <ul id="childCategoryList" class="category-list cat-panel__list"></ul>
                <input
                  type="text"
                  id="childInput"
                  class="category-input cat-panel__input"
                  placeholder="+ Enter키로 소분류 추가"
                  disabled
                />
              </section>
            </div>

            <!-- 하단 선택/수정  -->
            <div id="editSection" class="cat-modal__footer">
              <input type="hidden" id="editId" />
              <input type="hidden" id="editType" />

              <span class="cat-modal__selected-label">선택된 카테고리</span>
              <input type="text" id="categoryEditInput" class="category-input" placeholder="카테고리명 수정" disabled />

              <div class="cat-modal__actions">
                <button type="button" id="startEditBtn" class="btn btn-blue">수정</button>
                <button type="button" id="saveEditBtn" class="btn btn-blue" disabled>저장</button>
                <button type="button" id="cancelEditBtn" class="btn btn-red" disabled>취소</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <script>
      $(document).ready(function () {
        $.ajaxSetup({ cache: false });

        // 응답 판정 헬퍼
        function looksLikeFailure(res) {
          try {
            if (res == null) return false;
            if (typeof res === 'object') {
              if (res.success === false || res.status === 'error' || res.result === 'fail' || res.error) return true;
              return false;
            }
            const s = String(res).trim().toLowerCase();
            return s === 'fail' || s === 'error' || s === 'false';
          } catch (e) {
            return false;
          }
        }

        // =테이블 토글 (동적 행 대응: 위임)
        $(document).on('click', '.parentLevel', function () {
          const parentId = $(this).data('id');
          const middleRows = $(`.middleLevel[data-parent='${parentId}']`);
          const isHidden = middleRows.first().hasClass('hidden');
          if (isHidden) middleRows.removeClass('hidden');
          else {
            middleRows.addClass('hidden');
            middleRows.each(function () {
              const middleId = $(this).data('id');
              $(`.childLevel[data-parent='${middleId}']`).addClass('hidden');
            });
          }
        });

        $(document).on('click', '.middleLevel', function () {
          const middleId = $(this).data('id');
          const childRows = $(`.childLevel[data-parent='${middleId}']`);
          const isHidden = childRows.first().hasClass('hidden');
          if (isHidden) childRows.removeClass('hidden');
          else childRows.addClass('hidden');
        });

        $('#middle').on('click', function () {
          const middleRows = $('.middleLevel');
          const childRows = $('.childLevel');
          const arrow = $(this).find('.arrow');
          const isHidden = middleRows.first().hasClass('hidden');

          if (isHidden) {
            middleRows.removeClass('hidden');
            arrow.removeClass('rotate-up').addClass('rotate');
          } else {
            middleRows.addClass('hidden');
            childRows.addClass('hidden');
            arrow.removeClass('rotate').addClass('rotate-up');
          }
        });

        $('#child').on('click', function () {
          const childRows = $('.childLevel');
          const isHidden = childRows.first().hasClass('hidden');
          const arrow = $(this).find('.arrow');
          if (isHidden) {
            childRows.removeClass('hidden');
            arrow.removeClass('rotate-up').addClass('rotate');
          } else {
            childRows.addClass('hidden');
            arrow.removeClass('rotate').addClass('rotate-up');
          }
        });

        // 상태
        let selectedTopId = null;
        let selectedMiddleId = null;
        let selectedChildId = null;

        // 모달
        $('.btn-blue-b').on('click', function () {
          $('#categoryModal').css('display', 'flex');
          resetInputs();
          loadTopCategories();
        });
        $('#closeModal').on('click', function () {
          $('#categoryModal').css('display', 'none');
        });

        $('#startEditBtn').on('click', function () {
          if (!$('#editId').val()) {
            alert('먼저 카테고리를 선택하세요.');
            return;
          }
          $('#categoryEditInput').prop('disabled', false).focus();
          $('#saveEditBtn, #cancelEditBtn').prop('disabled', false);
        });

        // 로드 함수
        function loadTopCategories(callback) {
          $.ajax({
            url: '/productCategory/topCategories',
            data: { _: Date.now() },
            dataType: 'json',
            success: function (data) {
              const list = $('#topCategoryList').empty();
              $('#topCount').text(data ? data.length : 0);

              if (!data || data.length === 0) {
                $('#editId').val('');
                $('#editType').val('top');
                $('#categoryEditInput').val('').prop('disabled', true);
                $('#saveEditBtn, #cancelEditBtn').prop('disabled', true);
                $('#middleCategoryList, #childCategoryList').empty();
                $('#middleCount, #childCount').text('0');
                if (typeof callback === 'function') callback(false);
                return;
              }

              data.forEach((item) => {
                const li = $('<li>')
                  .addClass('category-button')
                  .data('id', item.categoryId)
                  .append($('<span>').addClass('name').text(item.categoryName))
                  .append($('<span>').addClass('arrow').html('&#8250;')); // 대/중만 화살표

                li.on('click', function () {
                  selectedTopId = $(this).data('id');
                  selectedMiddleId = null;
                  selectedChildId = null;

                  $('#topCategoryList li').removeClass('active');
                  $(this).addClass('active');

                  $('#middleInput').prop('disabled', false);
                  $('#childInput').prop('disabled', true);

                  loadMiddleCategories(selectedTopId, true);

                  $('#editId').val(selectedTopId);
                  $('#editType').val('top');
                  $('#categoryEditInput').val($(this).find('.name').text()).prop('disabled', true);
                  $('#saveEditBtn, #cancelEditBtn').prop('disabled', true);
                });

                list.append(li);
              });

              const firstLi = list.find('li').first();
              if (firstLi.length) firstLi.trigger('click');
              if (typeof callback === 'function') callback(true);
            },
          });
        }

        function loadMiddleCategories(topId, autoSelectFirstMiddle = false) {
          $.ajax({
            url: '/productCategory/middleCategories',
            data: { parentId: topId, _: Date.now() },
            dataType: 'json',
            success: function (data) {
              const list = $('#middleCategoryList').empty();
              $('#middleCount').text(data ? data.length : 0);

              if (!data || data.length === 0) {
                $('#childCategoryList').empty();
                $('#childCount').text('0');
                $('#middleInput').prop('disabled', false);
                $('#childInput').prop('disabled', true);
                return;
              }

              data.forEach((item) => {
                const li = $('<li>')
                  .addClass('category-button')
                  .data('id', item.categoryId)
                  .append($('<span>').addClass('name').text(item.categoryName))
                  .append($('<span>').addClass('arrow').html('&#8250;')); // 대/중만 화살표

                li.on('click', function () {
                  selectedMiddleId = $(this).data('id');

                  $('#middleCategoryList li').removeClass('active');
                  $(this).addClass('active');

                  $('#childInput').prop('disabled', false);

                  loadChildCategories(selectedMiddleId);

                  $('#editId').val(selectedMiddleId);
                  $('#editType').val('middle');
                  $('#categoryEditInput').val($(this).find('.name').text()).prop('disabled', true);
                  $('#saveEditBtn, #cancelEditBtn').prop('disabled', true);
                });

                list.append(li);
              });

              if (autoSelectFirstMiddle) {
                const firstMiddle = list.find('li').first();
                if (firstMiddle.length) firstMiddle.trigger('click');
                else {
                  $('#childCategoryList').empty();
                  $('#childCount').text('0');
                }
              }
            },
          });
        }

        function loadChildCategories(middleId, opts) {
          opts = opts || {}; // { highlightName?: string }

          $.ajax({
            url: '/productCategory/childCategories',
            data: { parentId: middleId, _: Date.now() },
            dataType: 'json',
            success: function (data) {
              const list = $('#childCategoryList').empty();
              $('#childCount').text(data ? data.length : 0);

              if (!data || data.length === 0) return;

              data.forEach(function (item) {
                const li = $('<li>')
                  .addClass('category-button')
                  .data('id', item.productId)
                  .append($('<span>').addClass('name').text(item.productName)); // 소분류 = 화살표 없음

                li.on('click', function () {
                  selectedChildId = $(this).data('id');
                  $('#childCategoryList li').removeClass('active');
                  $(this).addClass('active');

                  $('#editId').val(selectedChildId);
                  $('#editType').val('product');
                  $('#categoryEditInput').val($(this).find('.name').text()).prop('disabled', true);
                  $('#saveEditBtn, #cancelEditBtn').prop('disabled', true);
                });

                list.append(li);
              });

              if (opts.highlightName) {
                const $t = list
                  .find('li .name')
                  .filter(function () {
                    return $(this).text() === opts.highlightName;
                  })
                  .first()
                  .closest('li');

                if ($t.length) {
                  list.find('li').removeClass('active');
                  $t.addClass('active');
                  const container = list.get(0);
                  container.scrollTop = $t[0].offsetTop - 8;

                  selectedChildId = $t.data('id');
                  $('#editId').val(selectedChildId);
                  $('#editType').val('product');
                  $('#categoryEditInput').val(opts.highlightName).prop('disabled', true);
                  $('#saveEditBtn, #cancelEditBtn').prop('disabled', true);
                }
              }
            },
          });
        }

        // 등록
        function registerCategory(name, level, parentId = null) {
          $.ajax({
            url: '/productCategory/save',
            method: 'POST',
            data: { categoryName: name, categoryLevel: level, parentId: parentId },
            // 2xx면 우선 성공 처리, 응답이 명시적 실패 문자열이면 그때만 실패
            success: function (res) {
              if (looksLikeFailure(res)) {
                alert('등록 실패');
                return;
              }

              const createdAt = (res && res.createdAt ? String(res.createdAt) : new Date().toISOString()).substring(
                0,
                10
              );
              const nameVal = res && (res.name || res.categoryName) ? res.name || res.categoryName : name;
              const tbody = $('.productCategory-table tbody');

              if (level === 1) {
                const tr = `<tr class="parentLevel" data-id="${nameVal}">
                          <td>대분류</td><td>${nameVal}</td><td>${createdAt}</td>
                        </tr>`;
                tbody.append(tr);
                loadTopCategories();
                $('#topInput').val('');
              }

              if (level === 2) {
                const topName = $('#topCategoryList li.active').find('.name').text();
                if (topName) {
                  const tr = `<tr class="middleLevel" data-id="${nameVal}" data-parent="${topName}">
                            <td>중분류</td><td>${nameVal}</td><td>${createdAt}</td>
                          </tr>`;
                  tbody.append(tr);
                }
                loadMiddleCategories(selectedTopId, true);
                $('#middleInput').val('');
              }
            },
            error: function () {
              alert('등록 실패');
            },
          });
        }

        // 대/중분류 엔터 등록
        $('#topInput').on('keypress', function (e) {
          if (e.which === 13) {
            const v = $(this).val().trim();
            if (!v) return;
            registerCategory(v, 1);
          }
        });

        $('#middleInput').on('keypress', function (e) {
          if (e.which === 13 && selectedTopId) {
            const v = $(this).val().trim();
            if (!v) return;
            registerCategory(v, 2, selectedTopId);
          }
        });

        // 소분류 엔터 등록: 성공 시 무조건 즉시 리로드 & 하이라이트
        $('#childInput').on('keydown', function (e) {
          if (e.key !== 'Enter' || !selectedMiddleId) return;
          e.preventDefault();

          const name = $(this).val().trim();
          if (!name) return;

          const selectedStoreId = '${sessionScope.selectedStoredId}';

          $.ajax({
            url: '/productCategory/saveProduct',
            method: 'POST',
            data: { categoryId: selectedMiddleId, productName: name, storeId: selectedStoreId },
            success: function (res) {
              if (looksLikeFailure(res)) {
                alert('소분류 등록 실패');
                return;
              }
              $('#childInput').val('');
              loadChildCategories(selectedMiddleId, { highlightName: name });
            },
            error: function () {
              alert('소분류 등록 실패');
            },
          });
        });

        // 수정
        $('#saveEditBtn').on('click', function () {
          const type = $('#editType').val();
          const id = $('#editId').val();
          const newName = $('#categoryEditInput').val().trim();
          if (!newName) {
            alert('이름을 입력해주세요');
            return;
          }
          if (!id && type !== 'top') {
            alert('수정 대상이 없습니다.');
            return;
          }

          $.ajax({
            url: '/productCategory/updateCategoryName',
            method: 'POST',
            data: { id: id, type: type, newName: newName },
            success: function (res) {
              if (looksLikeFailure(res)) {
                alert('수정 실패');
                return;
              }
              alert('수정 완료');
              if (type === 'top') {
                loadTopCategories();
              } else if (type === 'middle') {
                if (selectedTopId) loadMiddleCategories(selectedTopId, true);
                else loadTopCategories();
              } else if (type === 'product') {
                if (selectedMiddleId) loadChildCategories(selectedMiddleId, { highlightName: newName });
                else if (selectedTopId) loadMiddleCategories(selectedTopId, true);
              }
              $('#categoryEditInput').prop('disabled', true);
              $('#saveEditBtn, #cancelEditBtn').prop('disabled', true);
            },
            error: function () {
              alert('서버 오류');
            },
          });
        });

        $('#cancelEditBtn').on('click', function () {
          const type = $('#editType').val();
          if (type === 'top' && selectedTopId) {
            $('#categoryEditInput').val($('#topCategoryList li.active').find('.name').text() || '');
          } else if (type === 'middle' && selectedMiddleId) {
            $('#categoryEditInput').val($('#middleCategoryList li.active').find('.name').text() || '');
          } else if (type === 'product' && selectedChildId) {
            $('#categoryEditInput').val($('#childCategoryList li.active').find('.name').text() || '');
          } else {
            $('#categoryEditInput').val('');
          }
          $('#categoryEditInput').prop('disabled', true);
          $('#saveEditBtn, #cancelEditBtn').prop('disabled', true);
        });

        // 초기화
        function resetInputs() {
          $('#topInput, #middleInput, #childInput').val('');
          $('#middleInput, #childInput').prop('disabled', true);
          $('#topCategoryList, #middleCategoryList, #childCategoryList').empty();
          $('#topCount, #middleCount, #childCount').text('0');

          selectedTopId = null;
          selectedMiddleId = null;
          selectedChildId = null;

          $('#editId').val('');
          $('#editType').val('top');
          $('#categoryEditInput').val('').prop('disabled', true);
          $('#saveEditBtn, #cancelEditBtn').prop('disabled', true);
        }
      });
    </script>
  </body>
</html>
