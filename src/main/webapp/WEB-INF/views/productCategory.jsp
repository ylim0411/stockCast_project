<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ include file="/WEB-INF/views/header.jsp" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


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
            <button id="middle" class="btn btn-blue" style="display: flex; gap: 10px; align-items: center;" >중분류 <span class="arrow rotate-up" >&#8250;</span></button>
            <button id="child" class="btn btn-blue" style="display: flex; gap: 10px; align-items: center;">소분류 <span class="arrow rotate-up">&#8250;</span></button>
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
            <c:forEach items="${categoryList}" var="item">
              <c:if test="${prevTop != item.topLevelCategoryName}">
                <tr class="parentLevel" data-id="${item.topLevelCategoryName}">
                  <td>대분류</td>
                  <td>${item.topLevelCategoryName}</td>
                  <td>${fn:substring(item.categoryCreatedAt, 0, 10)}</td>
                </tr>
                <c:set var="prevTop" value="${item.topLevelCategoryName}" />
                <c:set var="prevMiddle" value="" />
              </c:if>

              <c:if test="${prevMiddle != item.categoryName}">
                <tr class="middleLevel" data-id="${item.categoryName}" data-parent="${item.topLevelCategoryName}">
                  <td>중분류</td>
                  <td>${item.categoryName}</td>
                  <td>${fn:substring(item.categoryCreatedAt, 0, 10)}</td>
                </tr>
                <c:set var="prevMiddle" value="${item.categoryName}" />
              </c:if>

              <tr class="childLevel" data-parent="${item.categoryName}">
                <td>소분류</td>
                <td>${item.productName}</td>
                <td>${fn:substring(item.productCreatedAt, 0, 10)}</td>
              </tr>
            </c:forEach>
          </tbody>
        </table>

        <!-- 카테고리 등록 모달창 -->
        <div id="categoryModal" class="modal hidden">
          <div class="modal-content">
            <h2>상품 카테고리 편집</h2>

            <div>
              <!-- 대분류 -->
              <div>
                <h4>대분류(<span id="topCount">0</span>)</h4>
                <ul id="topCategoryList" class="category-list"></ul>
                <input type="text" id="topInput" class="category-input" placeholder="대분류 입력 후 Enter" />
              </div>

              <!-- 중분류 -->
              <div>
                <h4>중분류(<span id="middleCount">0</span>)</h4>
                <ul id="middleCategoryList" class="category-list"></ul>
                <input
                  type="text"
                  id="middleInput"
                  class="category-input"
                  placeholder="중분류 입력 후 Enter"
                  disabled
                />
              </div>

              <!-- 소분류 -->
              <div>
                <h4>소분류(<span id="childCount">0</span>)</h4>
                <ul id="childCategoryList" class="category-list"></ul>
                <input type="text" id="childInput" class="category-input" placeholder="소분류 입력 후 Enter" disabled />
              </div>
            </div>

            <!-- 수정 시작 버튼 -->
            <div>
              <button type="button" id="startEditBtn" class="btn btn-blue">수정</button>
            </div>

            <!-- 수정 영역 항상 보이고 input은 기본 disabled -->
            <div id="editSection">
              <input type="hidden" id="editId" />
              <input type="hidden" id="editType" />
              <input type="text" id="categoryEditInput" class="category-input" placeholder="카테고리명 수정" disabled />
              <div>
                <button type="button" class="btn btn-blue" id="saveEditBtn" disabled>저장</button>
                <button type="button" class="btn btn-red" id="cancelEditBtn" disabled>취소</button>
              </div>
            </div>

            <div class="btn btn-blue">
              <button type="button" class="btn" id="closeModal">닫기</button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <script>
      $(document).ready(function () {
        // 토글 관련 (기존 테이블 뷰)
        $('.parentLevel').click(function () {
          const parentId = $(this).data('id');
          const middleRows = $(`.middleLevel[data-parent='${parentId}']`);
          const isHidden = middleRows.first().hasClass('hidden');
          if (isHidden) {
            middleRows.removeClass('hidden');
          } else {
            middleRows.addClass('hidden');
            middleRows.each(function () {
              const middleId = $(this).data('id');
              $(`.childLevel[data-parent='${middleId}']`).addClass('hidden');
            });
          }
        });
        $('.middleLevel').click(function () {
          const middleId = $(this).data('id');
          const childRows = $(`.childLevel[data-parent='${middleId}']`);
          const isHidden = childRows.first().hasClass('hidden');
          if (isHidden) childRows.removeClass('hidden');
          else childRows.addClass('hidden');
        });

        $('#middle').click(function () {
          const middleRows = $('.middleLevel');
          const childRows = $('.childLevel');
          const arrow = $(this).find('.arrow');
          const isHidden = middleRows.first().hasClass('hidden');

          if (isHidden) {
            middleRows.removeClass('hidden');
            arrow.removeClass('rotate-up').addClass('rotate'); // 아래 방향
          } else {
            middleRows.addClass('hidden');
            childRows.addClass('hidden');
            arrow.removeClass('rotate').addClass('rotate-up'); // 위 방향
          }
        });

        $('#child').click(function () {
          const childRows = $('.childLevel');
          const isHidden = childRows.first().hasClass('hidden');
          const arrow = $(this).find('.arrow');
          if (isHidden) {
            childRows.removeClass('hidden');
            arrow.removeClass('rotate-up').addClass('rotate'); // 아래 방향
          } else {
            childRows.addClass('hidden');
            arrow.removeClass('rotate').addClass('rotate-up'); // 위 방향
          }
        });

        // 선택 ID 변수
        let selectedTopId = null;
        let selectedMiddleId = null;
        let selectedChildId = null;

        // 모달 열기: 최상단 대분류 자동 선택 및 수정 input 비활성
        $('.btn-blue-b').click(function () {
          $('#categoryModal').css('display', 'flex');
          resetInputs();
          loadTopCategories(function (autoSelected) {
            // 콜백 처리 필요시 여기에
          });
        });

        // 모달 닫기
        $('#closeModal').click(function () {
          $('#categoryModal').css('display', 'none');
        });

        // 수정 시작 버튼 클릭 - 수정 input 활성화, 버튼 활성화
        $('#startEditBtn').click(function () {
          if (!$('#editId').val()) {
            alert('먼저 카테고리를 선택하세요.');
            return;
          }
          $('#categoryEditInput').prop('disabled', false);
          $('#saveEditBtn').prop('disabled', false);
          $('#cancelEditBtn').prop('disabled', false);
          $('#categoryEditInput').focus();
        });

        // --- loadTopCategories: 첫 항목 자동 선택 ---
        function loadTopCategories(callback) {
          $.get('/productCategory/topCategories', function (data) {
            const list = $('#topCategoryList').empty();
            $('#topCount').text(data.length);
            if (!data || data.length === 0) {
              // 리스트 없으면 편집 영역 초기화 및 input 비활성
              $('#editId').val('');
              $('#editType').val('top');
              $('#categoryEditInput').val('');
              $('#categoryEditInput').prop('disabled', true);
              $('#saveEditBtn, #cancelEditBtn').prop('disabled', true);
              $('#middleCategoryList, #childCategoryList').empty();
              $('#middleCount, #childCount').text('0');
              if (typeof callback === 'function') callback(false);
              return;
            }

            data.forEach((item) => {
              const li = $('<li>').addClass('category-button').text(item.categoryName).data('id', item.categoryId);
              li.click(function () {
                selectedTopId = $(this).data('id');
                selectedMiddleId = null;
                selectedChildId = null;
                $('#topCategoryList li').removeClass('active');
                $(this).addClass('active');

                $('#middleInput').prop('disabled', false);
                $('#childInput').prop('disabled', true);

                loadMiddleCategories(selectedTopId, true);

                // 선택 시 편집 input 비활성 및 값 세팅
                $('#editId').val(selectedTopId);
                $('#editType').val('top');
                $('#categoryEditInput').val($(this).text());
                $('#categoryEditInput').prop('disabled', true);
                $('#saveEditBtn, #cancelEditBtn').prop('disabled', true);
              });
              list.append(li);
            });

            const firstLi = list.find('li').first();
            if (firstLi.length) {
              firstLi.trigger('click');
              if (typeof callback === 'function') callback(true);
            } else {
              if (typeof callback === 'function') callback(false);
            }
          });
        }

        // --- loadMiddleCategories ---
        function loadMiddleCategories(topId, autoSelectFirstMiddle = false) {
          $.get('/productCategory/middleCategories', { parentId: topId }, function (data) {
            const list = $('#middleCategoryList').empty();
            $('#middleCount').text(data.length);
            if (!data || data.length === 0) {
              $('#middleCategoryList').empty();
              $('#childCategoryList').empty();
              $('#childCount').text('0');
              $('#middleInput').prop('disabled', false);
              $('#childInput').prop('disabled', true);
              return;
            }

            data.forEach((item) => {
              const li = $('<li>').addClass('category-button').text(item.categoryName).data('id', item.categoryId);
              li.click(function () {
                selectedMiddleId = $(this).data('id');
                $('#middleCategoryList li').removeClass('active');
                $(this).addClass('active');

                $('#childInput').prop('disabled', false);

                loadChildCategories(selectedMiddleId);

                // 선택 시 편집 input 비활성 및 값 세팅
                $('#editId').val(selectedMiddleId);
                $('#editType').val('middle');
                $('#categoryEditInput').val($(this).text());
                $('#categoryEditInput').prop('disabled', true);
                $('#saveEditBtn, #cancelEditBtn').prop('disabled', true);
              });
              list.append(li);
            });

            if (autoSelectFirstMiddle) {
              const firstMiddle = list.find('li').first();
              if (firstMiddle.length) {
                firstMiddle.trigger('click');
              } else {
                $('#childCategoryList').empty();
                $('#childCount').text('0');
              }
            }
          });
        }

        // --- loadChildCategories ---
        function loadChildCategories(middleId) {
          $.get('/productCategory/childCategories', { parentId: middleId }, function (data) {
            const list = $('#childCategoryList').empty();
            $('#childCount').text(data.length);
            if (!data || data.length === 0) {
              $('#childCategoryList').empty();
              $('#childCount').text('0');
              return;
            }
            data.forEach((item) => {
              const li = $('<li>').addClass('category-button').text(item.productName).data('id', item.productId);
              li.click(function () {
                selectedChildId = $(this).data('id');
                $('#childCategoryList li').removeClass('active');
                $(this).addClass('active');

                // 선택 시 편집 input 비활성 및 값 세팅
                $('#editId').val(selectedChildId);
                $('#editType').val('product');
                $('#categoryEditInput').val($(this).text());
                $('#categoryEditInput').prop('disabled', true);
                $('#saveEditBtn, #cancelEditBtn').prop('disabled', true);
              });
              list.append(li);
            });
          });
        }

        // --- 등록 ---
        function registerCategory(name, level, parentId = null) {
          $.post(
            '/productCategory/save',
            {
              categoryName: name,
              categoryLevel: level,
              parentId: parentId,
            },
            function () {
              if (level === 1) loadTopCategories();
              if (level === 2) loadMiddleCategories(selectedTopId, true);
              if (level === 3) loadChildCategories(selectedMiddleId);
            }
          );
        }

        // Enter 등록 이벤트
        $('#topInput').keypress(function (e) {
          if (e.which === 13) {
            const v = $(this).val().trim();
            if (!v) return;
            registerCategory(v, 1);
            $(this).val('');
          }
        });
        $('#middleInput').keypress(function (e) {
          if (e.which === 13 && selectedTopId) {
            const v = $(this).val().trim();
            if (!v) return;
            registerCategory(v, 2, selectedTopId);
            $(this).val('');
          }
        });
        $('#childInput').keypress(function (e) {
          if (e.which === 13 && selectedMiddleId) {
            const name = $(this).val().trim();
            if (!name) return;
            const selectedStoreId = '${sessionScope.selectedStoredId}';
            $.post(
              '/productCategory/saveProduct',
              {
                categoryId: selectedMiddleId,
                productName: name,
                storeId: selectedStoreId,
              },
              function (res) {
                if (res === 'success') {
                  loadChildCategories(selectedMiddleId);
                  $('#childInput').val('');
                } else {
                  alert('소분류 등록 실패' + res);
                }
              }
            );
          }
        });

        // --- 수정 저장 ---
        $('#saveEditBtn').click(function () {
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
              if (res === 'success') {
                alert('수정 완료');
                if (type === 'top') {
                  loadTopCategories();
                } else if (type === 'middle') {
                  if (selectedTopId) loadMiddleCategories(selectedTopId, true);
                  else loadTopCategories();
                } else if (type === 'product') {
                  if (selectedMiddleId) loadChildCategories(selectedMiddleId);
                  else if (selectedTopId) loadMiddleCategories(selectedTopId, true);
                }
                // 수정 완료 후 편집 input 비활성화
                $('#categoryEditInput').prop('disabled', true);
                $('#saveEditBtn, #cancelEditBtn').prop('disabled', true);
              } else {
                alert('수정 실패');
              }
            },
            error: function () {
              alert('서버 오류');
            },
          });
        });

        // 취소: 편집 input 내용 원래 선택된 항목 이름으로 복원, input 비활성화
        $('#cancelEditBtn').click(function () {
          const type = $('#editType').val();
          if (type === 'top' && selectedTopId) {
            $('#categoryEditInput').val($('#topCategoryList li.active').text() || '');
          } else if (type === 'middle' && selectedMiddleId) {
            $('#categoryEditInput').val($('#middleCategoryList li.active').text() || '');
          } else if (type === 'product' && selectedChildId) {
            $('#categoryEditInput').val($('#childCategoryList li.active').text() || '');
          } else {
            $('#categoryEditInput').val('');
          }
          $('#categoryEditInput').prop('disabled', true);
          $('#saveEditBtn, #cancelEditBtn').prop('disabled', true);
        });

        // 초기화 함수
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
          $('#categoryEditInput').val('');
          $('#categoryEditInput').prop('disabled', true); // 기본 disabled
          $('#saveEditBtn, #cancelEditBtn').prop('disabled', true);
        }
      });
    </script>
  </body>
</html>
