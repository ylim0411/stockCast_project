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
        <select class="select">
          <option>전체</option>
          <option>서울</option>
          <option>경기</option>
        </select>
        <input type="text" class="input" placeholder="고객명 검색" />
        <button class="btn btn-blue">검색</button>
        <button class="btn btn-blue-b">점포 등록</button>
      </div>

      <!-- 점포 테이블 -->
      <table class="orderItems">
        <thead>
          <tr>
            <th>이름</th>
            <th>지역</th>
            <th>전화번호</th>
            <th>주소</th>
            <th>관리자</th>
            <th>액션</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>점포 A</td>
            <td>서울</td>
            <td>010-1111-2222</td>
            <td>서울시 강남구</td>
            <td>홍길동</td>
            <td><a href="#">수정</a> | <a href="#">삭제</a></td>
          </tr>
          <tr>
            <td>점포 B</td>
            <td>경기</td>
            <td>010-3333-4444</td>
            <td>경기도 성남시</td>
            <td>김영미</td>
            <td><a href="#">수정</a> | <a href="#">삭제</a></td>
          </tr>
        </tbody>
      </table>

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
