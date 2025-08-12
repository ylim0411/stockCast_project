<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ include
file="/WEB-INF/views/header.jsp" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <title>거래처 관리</title>
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/static/css/style.css"
    />
    <!-- <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/static/css/modal.css"
    /> -->
  </head>
  <body>
    <div class="container client-container">
      <!-- Title -->
      <div class="title-box">
        <p class="sub-title">거래처 관리</p>
        <h2 class="title">거래처 관리</h2>
      </div>

      <div class="section-wrap80">
        <!-- 검색/등록 영역 -->
        <div class="form-container">
          <form
            method="get"
            action="${pageContext.request.contextPath}/client/"
          >
            <input
              type="text"
              name="searchKeyword"
              placeholder="검색어 입력"
              value="${searchKeyword}"
            />
            <button type="submit" class="btn btn-blue-b">검색</button>
          </form>
          <div>
            <button class="btn btn-blue openAddModal">거래처 등록</button>
          </div>
        </div>

        <div class="table-container">
          <!-- 거래처 테이블 -->
          <table>
            <thead>
              <tr>
                <th>번호</th>
                <th>거래처</th>
                <th>사업자 등록번호</th>
                <th>담당자명</th>
                <th>등록일자</th>
                <th>수정일시</th>
                <th>중지일시</th>
                <th></th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="client" items="${clientList}">
                <tr>
                  <td>${client.clientId}</td>
                  <td>${client.clientName}</td>
                  <td>${client.businessNumber}</td>
                  <td>${client.ceoName}</td>
                  <td>${client.createdAt}</td>
                  <td>${client.updatedAt != null ? client.updatedAt : '-'}</td>
                  <td>${client.deletedAt != null ? client.deletedAt : '-'}</td>
                  <td>
                    <button
                      class="btn btn-blue openDetailModal"
                      data-client-id="${client.clientId}"
                      data-client-name="${client.clientName}"
                      data-business-number="${client.businessNumber}"
                      data-ceo-name="${client.ceoName}"
                      data-address="${client.address}"
                      data-contact="${client.contact}"
                      data-fax="${client.fax}"
                      data-email="${client.email}"
                      data-manager-name="${client.managerName}"
                      data-manager-contact="${client.managerContact}"
                      data-manager-email="${client.managerEmail}"
                      data-status="${client.status}"
                      data-created-at="${client.createdAt}"
                      data-deleted-at="${client.deletedAt}"
                    >
                      상세 보기
                    </button>
                  </td>
                  <td>
                    <button
                      class="btn btn-blue openEditModal"
                      data-client-id="${client.clientId}"
                      data-client-name="${client.clientName}"
                      data-business-number="${client.businessNumber}"
                      data-ceo-name="${client.ceoName}"
                      data-address="${client.address}"
                      data-contact="${client.contact}"
                      data-fax="${client.fax}"
                      data-email="${client.email}"
                      data-manager-name="${client.managerName}"
                      data-manager-contact="${client.managerContact}"
                      data-manager-email="${client.managerEmail}"
                      data-status="${client.status}"
                      data-created-at="${client.createdAt}"
                      data-deleted-at="${client.deletedAt}"
                    >
                      수정 하기
                    </button>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </div>

      <div id="clientDetailModal" class="modal hidden">
        <div class="modal-content">
          <h2>거래처 상세보기</h2>
          <form
            action="${pageContext.request.contextPath}/client/update"
            method="post"
          >
            <input type="hidden" name="clientId" />
            <!-- 1줄 -->
            <div style="display: flex; gap: 20px">
              <div style="flex: 1">
                <label>거래처 이름</label>
                <input type="text" name="clientName" required readonly />
              </div>
              <div style="flex: 1">
                <label>담당자명</label>
                <input type="text" name="managerName" readonly />
              </div>
            </div>

            <!-- 2줄 -->
            <div style="display: flex; gap: 20px">
              <div style="flex: 1">
                <label>사업자 등록번호</label>
                <input type="text" name="businessNumber" required readonly />
              </div>
              <div style="flex: 1">
                <label>담당자 연락처</label>
                <input type="text" name="managerContact" readonly />
              </div>
            </div>

            <!-- 3줄 -->
            <div style="display: flex; gap: 20px">
              <div style="flex: 1">
                <label>대표자명</label>
                <input type="text" name="ceoName" readonly />
              </div>
              <div style="flex: 1">
                <label>담당자 이메일</label>
                <input type="email" name="managerEmail" readonly />
              </div>
            </div>

            <!-- 4줄 -->
            <div>
              <div style="flex: 1">
                <label>사업장 주소</label>
                <input type="text" name="address" readonly />
              </div>
              <div style="flex: 1">
                <label>팩스번호</label>
                <input type="text" name="fax" readonly />
              </div>
            </div>

            <!-- 5줄 -->
            <div style="display: flex; gap: 20px">
              <div style="flex: 1">
                <label>거래처 연락처</label>
                <input type="text" name="contact" readonly />
              </div>
              <div style="flex: 1">
                <label>거래처 상태</label>
                <select name="status" required disabled>
                  <option value="정상">정상</option>
                  <option value="중지">중지</option>
                </select>
              </div>
            </div>

            <!-- 6줄 -->
            <div style="display: flex; gap: 20px">
              <div style="flex: 1">
                <label>거래처 이메일</label>
                <input type="email" name="email" readonly />
              </div>
              <div style="flex: 1"></div>
            </div>

            <!-- 버튼 -->
            <button
              type="button"
              class="btn submit-btn closeDetailModal"
              style="width: 100%"
            >
              닫기
            </button>
          </form>
        </div>
      </div>

      <div id="clientEditModal" class="modal hidden">
        <div class="modal-content">
          <h2>거래처 수정</h2>
          <form
            action="${pageContext.request.contextPath}/client/update"
            method="post"
          >
            <input type="hidden" name="clientId" />
            <!-- 1줄 -->
            <div style="display: flex; gap: 20px">
              <div style="flex: 1">
                <label>거래처 이름</label>
                <input type="text" name="clientName" required />
              </div>
              <div style="flex: 1">
                <label>담당자명</label>
                <input type="text" name="managerName" required />
              </div>
            </div>

            <!-- 2줄 -->
            <div style="display: flex; gap: 20px">
              <div style="flex: 1">
                <label>사업자 등록번호</label>
                <input type="text" name="businessNumber" required
                       pattern="^\d{3}-\d{2}-\d{5}$"
                       title="사업자등록번호 형식에 맞게 입력하세요 (예: 123-45-67890)" />
              </div>
              <div style="flex: 1">
                <label>담당자 연락처</label>
                <input
                  type="text"
                  name="managerContact"
                  pattern="^(01[0-9]-?\d{3,4}-?\d{4}|0\d{1,2}-?\d{3,4}-?\d{4})$"
                  title="휴대폰(예: 010-1234-5678 또는 01012345678), 집전화(예: 02-123-4567 또는 021234567) 형식으로 입력하세요"
                />
              </div>
            </div>

            <!-- 3줄 -->
            <div style="display: flex; gap: 20px">
              <div style="flex: 1">
                <label>대표자명</label>
                <input type="text" name="ceoName" required />
              </div>
              <div style="flex: 1">
                <label>담당자 이메일</label>
                <input type="email" name="managerEmail" />
              </div>
            </div>

            <!-- 4줄 -->
            <div style="display: flex; gap: 20px">
              <div style="flex: 1">
                <label>사업장 주소</label>
                <input type="text" name="address" required />
              </div>
              <div style="flex: 1">
                <label>팩스번호</label>
                <input
                  type="text"
                  name="fax"
                  pattern="^0\d{1,2}-?\d{3,4}-?\d{4}$"
                  title="팩스번호 형식: 02-123-4567 또는 021234567"
                />
              </div>
            </div>

            <!-- 5줄 -->
            <div style="display: flex; gap: 20px">
              <div style="flex: 1">
                <label>거래처 연락처</label>
                <input
                  type="text"
                  name="contact"
                  required
                  pattern="^(01[0-9]-?\d{3,4}-?\d{4}|0\d{1,2}-?\d{3,4}-?\d{4})$"
                  title="휴대폰(예: 010-1234-5678 또는 01012345678), 집전화(예: 02-123-4567 또는 021234567) 형식으로 입력하세요"
                />
              </div>
              <div style="flex: 1">
                <label>거래처 상태</label>
                <select name="status" required>
                  <option value="정상">정상</option>
                  <option value="중지">중지</option>
                </select>
              </div>
            </div>

            <!-- 6줄 -->
            <div style="display: flex; gap: 20px">
              <div style="flex: 1">
                <label>거래처 이메일</label>
                <input type="email" name="email" required />
              </div>
              <div style="flex: 1"></div>
            </div>

            <!-- 버튼 -->
            <div class="btn-box">
              <button type="submit" class="btn submit-btn">수정</button>
              <button type="button" class="closeEditModal btn cencle-btn">
                취소
              </button>
            </div>
          </form>
        </div>
      </div>
      <div id="clienAddModal" class="modal hidden">
        <div class="modal-content">
          <h2>거래처 등록</h2>
          <form
            action="${pageContext.request.contextPath}/client/add"
            method="post"
            style="
              flex-direction: column;
              gap: 20px;
              max-width: 800px;
              margin: 0 auto;
            "
          >
            <!-- 1줄 -->
            <div style="display: flex; gap: 20px">
              <div style="flex: 1">
                <label>거래처 이름</label>
                <input type="text" name="clientName" required />
              </div>
              <div style="flex: 1">
                <label>담당자명</label>
                <input type="text" name="managerName" required />
              </div>
            </div>

            <!-- 2줄 -->
            <div style="display: flex; gap: 20px">
              <div style="flex: 1">
                <label>사업자 등록번호</label>
                <input type="text" name="businessNumber" required
                       pattern="^\d{3}-\d{2}-\d{5}$"
                       title="사업자등록번호 형식에 맞게 입력하세요 (예: 123-45-67890)" />
              </div>
              <div style="flex: 1">
                <label>담당자 연락처</label>
                <input
                  type="text"
                  name="managerContact"
                  pattern="^(01[0-9]-?\d{3,4}-?\d{4}|0\d{1,2}-?\d{3,4}-?\d{4})$"
                  title="휴대폰(예: 010-1234-5678 또는 01012345678), 집전화(예: 02-123-4567 또는 021234567) 형식으로 입력하세요"
                />
              </div>
            </div>

            <!-- 3줄 -->
            <div style="display: flex; gap: 20px">
              <div style="flex: 1">
                <label>대표자명</label>
                <input type="text" name="ceoName" required />
              </div>
              <div style="flex: 1">
                <label>담당자 이메일</label>
                <input type="email" name="managerEmail" />
              </div>
            </div>

            <!-- 4줄 -->
            <div style="display: flex; gap: 20px">
              <div style="flex: 1">
                <label>사업장 주소</label>
                <input type="text" name="address" required />
              </div>
              <div style="flex: 1">
                <label>팩스번호</label>
                <input
                  type="text"
                  name="fax"
                  pattern="^0\d{1,2}-?\d{3,4}-?\d{4}$"
                  title="팩스번호 형식: 02-123-4567 또는 021234567"
                />
              </div>
            </div>

            <!-- 5줄 -->
            <div style="display: flex; gap: 20px">
              <div style="flex: 1">
                <label>거래처 연락처</label>
                <input
                  type="text"
                  name="contact"
                  required
                  pattern="^(01[0-9]-?\d{3,4}-?\d{4}|0\d{1,2}-?\d{3,4}-?\d{4})$"
                  title="휴대폰(예: 010-1234-5678 또는 01012345678), 집전화(예: 02-123-4567 또는 021234567) 형식으로 입력하세요"
                />
              </div>
              <div style="flex: 1">
                <label>거래처 상태</label>
                <select name="status" required>
                  <option value="정상" selected>정상</option>
                  <option value="중지">중지</option>
                </select>
              </div>
            </div>

            <!-- 6줄 -->
            <div style="display: flex; gap: 20px">
              <div style="flex: 1">
                <label>거래처 이메일</label>
                <input type="email" name="email" required />
              </div>
              <div style="flex: 1"></div>
            </div>

            <!-- 버튼 -->
            <div class="btn-box">
              <button type="submit" class="btn btn-blue-b" style="width: 100px">
                추가
              </button>
              <button type="button" class="closeAddModal" style="width: 100px">
                취소
              </button>
            </div>
          </form>
        </div>
      </div>

      <!-- 발주 페이징 -->
      <div class="paging">
        <c:choose>
          <c:when test="${paging.page <= 1}">
            <span>&lt;</span>
          </c:when>
          <c:otherwise>
            <a href="?page=${paging.page - 1}&searchKeyword=${searchKeyword}"
              >&lt;</a
            >
          </c:otherwise>
        </c:choose>

        <c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
          <c:choose>
            <c:when test="${i == paging.page}">
              <span class="page">${i}</span>
            </c:when>
            <c:otherwise>
              <a href="?page=${i}&searchKeyword=${searchKeyword}">${i}</a>
            </c:otherwise>
          </c:choose>
        </c:forEach>

        <c:choose>
          <c:when test="${paging.page >= paging.maxPage}">
            <span>&gt;</span>
          </c:when>
          <c:otherwise>
            <a href="?page=${paging.page + 1}&searchKeyword=${searchKeyword}"
              >&gt;</a
            >
          </c:otherwise>
        </c:choose>
      </div>
      <!-- paging -->
    </div>
    <script>
      $(document).ready(function () {
        //수정 모달
        $(document).on("click", ".openEditModal", function () {
          const button = $(this);

          $("#clientEditModal").css("display", "flex");

          // 각 input 요소에 데이터 채우기
          $("input[name='clientId']").val(button.data("client-id"));
          $("input[name='clientName']").val(button.data("client-name"));
          $("input[name='managerName']").val(button.data("manager-name"));
          $("input[name='businessNumber']").val(button.data("business-number"));
          $("input[name='managerContact']").val(button.data("manager-contact"));
          $("input[name='ceoName']").val(button.data("ceo-name"));
          $("input[name='managerEmail']").val(button.data("manager-email"));
          $("input[name='address']").val(button.data("address"));
          $("input[name='fax']").val(button.data("fax"));
          $("input[name='contact']").val(button.data("contact"));
          $("select[name='status']").val(button.data("status"));
          $("input[name='createdAt']").val(button.data("created-at"));
          $("input[name='email']").val(button.data("email"));
          $("input[name='deletedAt']").val(button.data("deleted-at"));
        });
        $(".closeEditModal").click(function () {
          $("#clientEditModal").css("display", "none");
        });

        //상세보기 모달
        $(document).on("click", ".openDetailModal", function () {
          const button = $(this);

          $("#clientDetailModal").css("display", "flex");

          // 각 input 요소에 데이터 채우기
          $("input[name='clientId']").val(button.data("client-id"));
          $("input[name='clientName']").val(button.data("client-name"));
          $("input[name='managerName']").val(button.data("manager-name"));
          $("input[name='businessNumber']").val(button.data("business-number"));
          $("input[name='managerContact']").val(button.data("manager-contact"));
          $("input[name='ceoName']").val(button.data("ceo-name"));
          $("input[name='managerEmail']").val(button.data("manager-email"));
          $("input[name='address']").val(button.data("address"));
          $("input[name='fax']").val(button.data("fax"));
          $("input[name='contact']").val(button.data("contact"));
          $("select[name='status']").val(button.data("status"));
          $("input[name='createdAt']").val(button.data("created-at"));
          $("input[name='email']").val(button.data("email"));
          $("input[name='deletedAt']").val(button.data("deleted-at"));
        });

        $(".closeDetailModal").click(function () {
          $("#clientDetailModal").css("display", "none");
        });

        //등록 모달
        $(document).on("click", ".openAddModal", function () {
          const button = $(this);

          $("#clienAddModal").css("display", "flex");

          // 각 input 요소에 데이터 채우기
          $("input[name='clientId']").val(button.data("client-id"));
          $("input[name='clientName']").val(button.data("client-name"));
          $("input[name='managerName']").val(button.data("manager-name"));
          $("input[name='businessNumber']").val(button.data("business-number"));
          $("input[name='managerContact']").val(button.data("manager-contact"));
          $("input[name='ceoName']").val(button.data("ceo-name"));
          $("input[name='managerEmail']").val(button.data("manager-email"));
          $("input[name='address']").val(button.data("address"));
          $("input[name='fax']").val(button.data("fax"));
          $("input[name='contact']").val(button.data("contact"));
          $("select[name='status']").val("정상");
          $("input[name='createdAt']").val(button.data("created-at"));
          $("input[name='email']").val(button.data("email"));
          $("input[name='deletedAt']").val(button.data("deleted-at"));
        });

        $(".closeAddModal").click(function () {
          $("#clienAddModal").css("display", "none");
        });
      });
    </script>
  </body>
</html>
