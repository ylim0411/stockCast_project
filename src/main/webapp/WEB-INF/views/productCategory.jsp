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

    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/modal.css"/>


</head>
<style>
    .hidden{
        display: none;
    }
</style>
<body>
	<div id="productCategory" class="container">
		<div>
			<h1>상품 카테고리 목록</h1>
			<button id="middle" class="btn btn-blue">중분류 모두 접기</button>
			<button id="child" class="btn btn-blue">소분류 모두 접기</button>

            <!-- 카테고리 등록 버튼 -->
            <div class="form-container" style="margin-bottom: 10px">
              <button class="btn btn-blue-b">카테고리 등록</button>
            </div>

			<c:set var="top" value="" />
            <c:set var="middle" value="" />
			<table>
				<thead>
					<tr>
						<th>카테고리 레벨</th>
						<th>카테고리/상품명</th>
						<th>카테고리 등록일시</th>
					</tr>
				</thead>
				<tbody>
                    <c:forEach items="${categoryList}" var="item">

                      <c:if test="${prevTop != item.topLevelCategoryName}">
                        <tr class="parentLevel" data-id="${item.topLevelCategoryName}">
                          <td>대분류</td>
                          <td>${item.topLevelCategoryName}</td>
                          <td>${item.categoryCreatedAt}</td>
                          <td></td>
                        </tr>
                        <c:set var="prevTop" value="${item.topLevelCategoryName}" />
                        <c:set var="prevMiddle" value="" />
                      </c:if>

                      <c:if test="${prevMiddle != item.categoryName}">
                        <tr class="middleLevel" data-id="${item.categoryName}" data-parent="${item.topLevelCategoryName}">
                          <td>중분류</td>
                          <td>${item.categoryName}</td>
                          <td>${item.categoryCreatedAt}</td>
                          <td></td>
                        </tr>
                        <c:set var="prevMiddle" value="${item.categoryName}" />
                      </c:if>

                      <tr class="childLevel" data-parent="${item.categoryName}">
                        <td>소분류</td>
                        <td>${item.productName}</td>
                        <td>${item.productCreatedAt}</td>
                      </tr>
                    </c:forEach>
				</tbody>
			</table>
            <!-- 카테고리 등록 모달창 -->
            <div id="categoryModal" class="modal hidden">
              <div class="modal-content" style="width: 800px; display: flex; flex-direction: column; gap: 20px;">
                <h2>상품 카테고리 편집</h2>

                <div style="display: flex; gap: 10px; justify-content: space-between;">
                  <!-- 대분류 -->
                  <div style="flex: 1">
                    <h4>대분류(<span id="topCount">0</span>)</h4>
                    <ul id="topCategoryList" class="category-list"></ul>
                    <input type="text" id="topInput" class="category-input" placeholder="대분류 입력 후 Enter">
                  </div>

                  <!-- 중분류 -->
                  <div style="flex: 1">
                    <h4>중분류(<span id="middleCount">0</span>)</h4>
                    <ul id="middleCategoryList" class="category-list"></ul>
                    <input type="text" id="middleInput" class="category-input" placeholder="중분류 입력 후 Enter" disabled>
                  </div>

                  <!-- 소분류 -->
                  <div style="flex: 1">
                    <h4>소분류(<span id="childCount">0</span>)</h4>
                    <ul id="childCategoryList" class="category-list"></ul>
                    <input type="text" id="childInput" class="category-input" placeholder="소분류 입력 후 Enter" disabled>
                  </div>
                </div>

                <div style="margin-top: 10px; text-align: right;">
                  <button type="button" class="btn" id="editBtn">수정</button>
                  <button type="button" class="btn btn-danger" id="deleteBtn">삭제</button>
                  <button type="button" class="btn" id="closeModal">닫기</button>
                </div>
              </div>
            </div>


		</div>
	</div>
</body>
<script>
    $(document).ready(function () {
        // 대분류 클릭
        $(".parentLevel").click(function () {
            const parentId = $(this).data("id");
            const middleRows = $(`.middleLevel[data-parent='${parentId}']`);
            const isHidden = middleRows.first().hasClass("hidden");

            if (isHidden) {
                middleRows.removeClass("hidden");
            } else {
                middleRows.addClass("hidden");
                middleRows.each(function () {
                    const middleId = $(this).data("id");
                    $(`.childLevel[data-parent='${middleId}']`).addClass("hidden");
                });
            }
        });

        // 중분류 클릭
        $(".middleLevel").click(function () {
            const middleId = $(this).data("id");
            const childRows = $(`.childLevel[data-parent='${middleId}']`);
            const isHidden = childRows.first().hasClass("hidden");

            if (isHidden) {
                childRows.removeClass("hidden");
            } else {
                childRows.addClass("hidden");
            }
        });

        // 중분류 접기/펼치기
        $("#middle").click(function () {
            const middleRows = $(".middleLevel");
            const childRows = $(".childLevel");
            const isHidden = middleRows.first().hasClass("hidden");

            if (isHidden) {
                middleRows.removeClass("hidden");
                $(this).text("중분류 모두 접기");
            } else {
                middleRows.addClass("hidden");
                childRows.addClass("hidden");
                $(this).text("중분류 모두 펼치기");
            }
        });

        // 소분류 접기/펼치기
        $("#child").click(function () {
            const childRows = $(".childLevel");
            const isHidden = childRows.first().hasClass("hidden");

            if (isHidden) {
                childRows.removeClass("hidden");
                $(this).text("소분류 모두 접기");
            } else {
                childRows.addClass("hidden");
                $(this).text("소분류 모두 펼치기");
            }
        });

      // 모달 열기
      $(".btn-blue-b").click(function () {
        $("#categoryModal").css("display", "flex");
        loadTopCategories();
        resetInputs();
      });

      // 모달 닫기
      $("#closeModal").click(function () {
        $("#categoryModal").css("display", "none");
      });

        let selectedTopId = null;
        let selectedMiddleId = null;
        let selectedChildId = null;

        // 대분류 불러오기
        function loadTopCategories() {
          $.get("/productCategory/topCategories", function (data) {
            const list = $("#topCategoryList").empty();
            $("#topCount").text(data.length);
            data.forEach(item => {
              const li = $("<li>").addClass("category-button").text(item.categoryName).data("id", item.categoryId);
              li.click(function () {
                selectedTopId = $(this).data("id");
                selectedMiddleId = null;
                selectedChildId = null;
                $("#topCategoryList li").removeClass("active");
                $(this).addClass("active");
                $("#middleInput").prop("disabled", false);
                $("#childInput").prop("disabled", true);
                loadMiddleCategories(selectedTopId);
                $("#middleCategoryList, #childCategoryList").empty();
              });
              list.append(li);
            });
          });
        }

        // 중분류 불러오기
        function loadMiddleCategories(topId) {
          $.get("/productCategory/middleCategories", { parentId: topId }, function (data) {
            const list = $("#middleCategoryList").empty();
            $("#middleCount").text(data.length);
            data.forEach(item => {
              const li = $("<li>").addClass("category-button").text(item.categoryName).data("id", item.categoryId);
              li.click(function () {
                selectedMiddleId = $(this).data("id");
                $("#middleCategoryList li").removeClass("active");
                $(this).addClass("active");
                $("#childInput").prop("disabled", false);
                loadChildCategories(selectedMiddleId);
              });
              list.append(li);
            });
          });
        }

        // 소분류 불러오기
        function loadChildCategories(middleId) {
          $.get("/productCategory/childCategories", { parentId: middleId }, function (data) {
            const list = $("#childCategoryList").empty();
            $("#childCount").text(data.length);
            data.forEach(item => {
              const li = $("<li>").addClass("category-button").text(item.categoryName).data("id", item.categoryId);
              li.click(function () {
                selectedChildId = $(this).data("id");
                $("#childCategoryList li").removeClass("active");
                $(this).addClass("active");
              });
              list.append(li);
            });
          });
        }


      // 등록 핸들러
      function registerCategory(name, level, parentId = null) {
        $.post("/productCategory/save", {
          categoryName: name,
          categoryLevel: level,
          parentId: parentId
        }, function () {
          if (level === 1) loadTopCategories();
          if (level === 2) loadMiddleCategories(selectedTopId);
          if (level === 3) loadChildCategories(selectedMiddleId);
        });
      }

      // Enter 키 입력 시 등록
      $("#topInput").keypress(function (e) {
        if (e.which === 13) {
          registerCategory($(this).val(), 1);
          $(this).val("");
        }
      });

      $("#middleInput").keypress(function (e) {
        if (e.which === 13 && selectedTopId) {
          registerCategory($(this).val(), 2, selectedTopId);
          $(this).val("");
        }
      });

      $("#childInput").keypress(function (e) {
        if (e.which === 13 && selectedMiddleId) {
          registerCategory($(this).val(), 3, selectedMiddleId);
          $(this).val("");
        }
      });

      // 초기화
      function resetInputs() {
        $("#topInput, #middleInput, #childInput").val("");
        $("#middleInput, #childInput").prop("disabled", true);
        $("#topCategoryList, #middleCategoryList, #childCategoryList").empty();
        $("#topCount, #middleCount, #childCount").text("0");
        selectedTopId = null;
        selectedMiddleId = null;
      }
    });

</script>
</html>
