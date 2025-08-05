<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ include
file="/WEB-INF/views/header.jsp" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>마이페이지</title>
    <script src="${pageContext.request.contextPath}/static/js/jquery-3.7.1.min.js"></script>
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/static/css/style.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/static/css/modal.css"
    />
  </head>
  <body>
    <div class="container">
      <!-- 타이틀 -->
      <div class="title-box">
        <div class="title">마이 페이지</div>
      </div>

      <!-- 관리자 정보 -->
      <div class="title-box">
        <div class="title" style="font-size: 18px">관리자 정보</div>
      </div>
      <form action="/admin/update" method="post">
        <table class="orderItems" style="width: 60%; margin-bottom: 40px">
          <tr>
            <th>이름</th>
            <td>
              <input
                type="text"
                name="adminName"
                placeholder="이름"
                value="${sessionScope.loginedAdminDTO.adminName}"
                required
              />
            </td>
          </tr>
          <tr>
            <th>아이디</th>
            <td>
              <input
                type="text"
                name="loginId"
                placeholder="아이디"
                value="${sessionScope.loginedAdminDTO.loginId}"
                required
              />
            </td>
          </tr>
          <tr>
            <th>비밀번호</th>
            <td style="position: relative">
              <input
                style="border: none; text-align: center"
                type="password"
                id="loginPw"
                name="loginPw"
                placeholder="비밀번호"
                value="${sessionScope.loginedAdminDTO.loginPw}"
                required
              />
              <button
                type="button"
                onclick="togglePassword()"
                id="togglePwBtn"
                style="
                  position: absolute;
                  right: 10px;
                  top: 50%;
                  transform: translateY(-50%);
                  background: none;
                  border: none;
                  font-size: 16px;
                  cursor: pointer;
                "
              >
                👁️
              </button>
            </td>
          </tr>
          <tr>
            <th>사업자 등록번호</th>
            <td>
              <input
                type="text"
                name="businessNumber"
                placeholder="사업자 등록번호"
                value="${sessionScope.loginedAdminDTO.businessNumber}"
                required
              />
            </td>
          </tr>
        </table>
        <input type="submit" value="수정하기" class="btn btn-blue" />
      </form>
      <br /><br /><br />
      <!-- 관리 점포 목록 -->
      <div class="title-box">
        <div class="title" style="font-size: 18px">관리 점포 목록</div>
      </div>

      <!-- 검색 바 -->
      <div class="form-container" style="margin-bottom: 10px">
        <button class="btn btn-blue-b">점포 등록</button>
      </div>

      <table class="orderItems" style="table-layout: fixed; width: 100%">
        <colgroup>
          <col style="width: 6%" />
          <!-- storeId -->
          <col style="width: 8%" />
          <!-- adminId -->
          <col style="width: 15%" />
          <!-- storeName -->
          <col style="width: 30%" />
          <!-- storeAddress -->
          <col style="width: 15%" />
          <!-- storePhone -->
          <col style="width: 20%" />
          <!-- storeEmail -->
          <col style="width: 6%" />
          <!-- action -->
        </colgroup>
        <thead>
          <tr>
            <th>점포 ID</th>
            <th>관리자 ID</th>
            <th>점포명</th>
            <th>주소</th>
            <th>전화번호</th>
            <th>이메일</th>
            <th>수정</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="store" items="${storeList}">
            <form
              method="post"
              action="${pageContext.request.contextPath}/store/update"
            >
              <tr class="selectable-row">
                <td>
                  <input
                    type="text"
                    name="storeId"
                    value="${store.storeId}"
                    readonly
                  />
                </td>
                <td>
                  <input
                    type="text"
                    name="adminId"
                    value="${store.adminId}"
                    readonly
                  />
                </td>
                <td>
                  <input
                    type="text"
                    name="storeName"
                    value="${store.storeName}"
                    readonly
                  />
                </td>
                <td>
                  <input
                    type="text"
                    name="storeAddress"
                    value="${store.storeAddress}"
                    readonly
                  />
                </td>
                <td>
                  <input
                    type="text"
                    name="storePhone"
                    value="${store.storePhone}"
                    readonly
                  />
                </td>
                <td>
                  <input
                    type="text"
                    name="storeEmail"
                    value="${store.storeEmail}"
                    readonly
                  />
                </td>
                <td>
                  <button type="button" class="editBtn">수정</button>
                  <button type="submit" class="saveBtn" style="display: none">
                    저장
                  </button>
                  <button type="button" class="cancelBtn" style="display: none">
                    취소
                  </button>
                </td>
              </tr>
            </form>
          </c:forEach>
        </tbody>
      </table>

      <div id="storeModal" class="modal hidden">
        <div class="modal-content">
          <h2>점포 등록</h2>
          <form
            id="storeForm"
            action="${pageContext.request.contextPath}/store/save"
            method="post"
          >
            <!-- 현재 로그인한 관리자 ID 숨김 필드로 넘기기 -->
            <input
              type="hidden"
              name="adminId"
              value="${sessionScope.loginedAdminDTO.adminId}"
            />

            <label>점포명</label>
            <input type="text" name="storeName" required />

            <label>주소</label>
            <input type="text" name="storeAddress" required />

            <label>전화번호</label>
            <input type="text" name="storePhone" required />

            <label>이메일</label>
            <input type="email" name="storeEmail" required />

            <div style="margin-top: 15px; text-align: right">
              <button type="submit" class="btn btn-blue">등록</button>
              <button type="button" id="closeModal" class="btn">닫기</button>
            </div>
          </form>
        </div>
      </div>

      <!-- 페이지네이션 -->
      <div class="pagination" style="margin-top: 20px">
        <button class="btn">&lt;</button>
        <button class="btn btn-blue">1</button>
        <button class="btn">2</button>
        <button class="btn">3</button>
        <button class="btn">4</button>
        <button class="btn">&gt;</button>
      </div>
    </div>
    <script>
      const rows = document.querySelectorAll(".selectable-row");
      window.onload = function () {
        rows.forEach((row) => {
          const selectedStoreId =
            '<%= session.getAttribute("selectedStoredId") %>';
          const input = row.querySelector('td input[name="storeId"]');
          if (input && input.value === selectedStoreId) {
            row.classList.add("selected-row");
          }
        });
      };

      rows.forEach((row) => {
        row.addEventListener("click", () => {
          // 이전 선택 해제
          document
            .querySelectorAll(".selected-row")
            .forEach((r) => r.classList.remove("selected-row"));
          // 현재 선택
          row.classList.add("selected-row");
          const input = row.querySelector('td input[name="storeId"]');
          const selectedId = input ? input.value : null;

          console.log("선택된 점포 ID:", selectedId);

          // 서버에 세션 저장 요청 (POST 방식)
          if (selectedId) {
            $.ajax({
              type: "post",
              url: "/store/setSelectedStoreId",
              data: {
                storeId: selectedId,
              },
              success: function () {
                console.log("세션 저장 완료");
              },
              error: function (xhr) {
                console.error("요청 실패:", xhr.status);
              },
            });
          }
        });
      });

      $(document).ready(function () {
        $(".editBtn").click(function () {
          const $tr = $(this).closest("tr");
          // 점포ID, 관리자ID는 readonly 유지, 나머지만 해제
          $tr.find("input").each(function () {
            const name = $(this).attr("name");
            if (name !== "storeId" && name !== "adminId") {
              $(this).prop("readonly", false);
              // 원래 값 저장
              $(this).data("original-value", $(this).val());
            }
          });

          $(this).hide();
          $tr.find(".saveBtn, .cancelBtn").show();
        });

        $(".cancelBtn").click(function () {
          const $tr = $(this).closest("tr");
          $tr.find("input").each(function () {
            const name = $(this).attr("name");
            if (name !== "storeId" && name !== "adminId") {
              $(this).val($(this).data("original-value"));
              $(this).prop("readonly", true);
            }
          });

          $tr.find(".saveBtn, .cancelBtn").hide();
          $tr.find(".editBtn").show();
        });
      });
      $(document).ready(function () {
        // 점포 등록 버튼 클릭 시 모달 열기
        $(".btn-blue-b").click(function () {
          $("#storeModal").css("display", "flex");
        });

        // 모달 닫기 버튼 클릭 시 모달 닫기
        $("#closeModal").click(function () {
          $("#storeModal").css("display", "none");
        });
      });
      function togglePassword() {
        const pwField = document.getElementById("loginPw");
        const toggleBtn = document.getElementById("togglePwBtn");

        if (pwField.type === "password") {
          pwField.type = "text";
          toggleBtn.textContent = "🙈"; // 보기 중 → 눈 가린 이모지
        } else {
          pwField.type = "password";
          toggleBtn.textContent = "👁️"; // 보기 전 → 눈 뜬 이모지
        }
      }
    </script>
  </body>
</html>
