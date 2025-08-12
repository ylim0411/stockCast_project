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
      <div class="title-box">
        <p class="sub-title"></p>
        <h2 class="title">마이 페이지</h2>
      </div>
      <div
        class="section-wrap85"
        style="display: flex; flex-direction: column; gap: 10px"
      >
        <!-- section-box1 관리자 정보 -->
        <form action="/admin/update" method="post">
          <div class="btn-box" style="margin-bottom: 10px">
            <input
              type="button"
              id="adminEditBtn"
              value="수정하기"
              class="btn btn-blue"
            />
            <button type="button" class="btn btn-red" onclick="submitDelete()">
              탈퇴하기
            </button>
          </div>

          <div
            class="section-box section-box1"
            style="height: 200px; min-height: 200px; margin: 0"
          >
            <div class="section-header">관리자 정보</div>
            <div class="section-body">
              <div class="row">
                <div class="col">
                  <p class="label">이름</p>
                  <p class="value">
                    <input
                      type="text"
                      name="adminName"
                      value="${sessionScope.loginedAdminDTO.adminName}"
                      readonly
                      required
                    />
                  </p>
                </div>
                <div class="col">
                  <p class="label">아이디</p>
                  <p class="value">
                    <input
                      type="text"
                      name="loginId"
                      value="${sessionScope.loginedAdminDTO.loginId}"
                      readonly
                      required
                    />
                  </p>
                </div>
                <div class="col">
                  <p class="label">비밀번호</p>
                  <p class="value" style="position: relative">
                    <input
                      type="password"
                      id="loginPw"
                      name="loginPw"
                      value="${sessionScope.loginedAdminDTO.loginPw}"
                      readonly
                      required
                      style="
                        text-align: center;
                        height: 30px;
                        outline: none;
                        width: 80%;
                        border: none;
                        font-size: 16px;
                      "
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
                        cursor: pointer;
                      "
                    >
                      <img
                        id="togglePwIcon"
                        src="${pageContext.request.contextPath}/static/images/eye-close.png"
                        alt="보기"
                        style="width: 20px; height: 20px"
                      />
                    </button>
                  </p>
                  <p
                    id="pwErrorMsg"
                    class="error-msg"
                    style="
                      display: none;
                      position: relative;
                      top: 17px;
                      left: 0px;
                    "
                  ></p>
                </div>

                <div class="col">
                  <p class="label">사업자 등록번호</p>
                  <p class="value">
                    <input
                      type="text"
                      name="businessNumber"
                      value="${sessionScope.loginedAdminDTO.businessNumber}"
                      readonly
                      required
                    />
                  </p>
                </div>
              </div>
            </div>
          </div>
        </form>

        <!-- 점포 등록 버튼 -->
        <div class="btn-box">
          <!-- 점포등록 조회 넣어주세요~! -->
          <div class="form-container">
            <form
              method="get"
              action="${pageContext.request.contextPath}/mypage/"
            >
              <input
                type="text"
                name="searchKeyword"
                placeholder="검색어 입력"
                value="${searchKeyword}"
              />
              <button type="submit" class="btn btn-blue-b">검색</button>
            </form>
          </div>
          <button type="button" class="btn submit-btn">점포 등록</button>
        </div>

        <!-- section-box2 점포관리 -->
        <div class="section-box section-box2" style="margin: 0">
          <div class="section-header">점포 목록</div>

          <div class="mypage-items">
            <!-- 헤더 -->
            <div class="mypage-item header">
              <div>번호</div>
              <div>점포명</div>
              <div>주소</div>
              <div>전화번호</div>
              <div>이메일</div>
              <div>수정</div>
            </div>

            <!-- 아이템 -->
            <c:forEach var="store" items="${storeList}" varStatus="status">
              <form
                method="post"
                action="${pageContext.request.contextPath}/store/update"
                class="store-form"
              >
                <!-- 관리자 ID(hidden) -->
                <input type="hidden" name="adminId" value="${store.adminId}" />
                <input
                  type="hidden"
                  name="storeId"
                  value="${store.storeId}"
                  readonly
                />
                <div class="mypage-item">
                  <!-- 점포 ID -->
                  <div>${status.index + 1}</div>
                  <!-- 점포명 -->
                  <div>
                    <input
                      type="text"
                      name="storeName"
                      value="${store.storeName}"
                      readonly
                    />
                  </div>
                  <!-- 주소 -->
                  <div>
                    <input
                      type="text"
                      name="storeAddress"
                      value="${store.storeAddress}"
                      readonly
                    />
                  </div>
                  <!-- 전화번호 -->
                  <div>
                    <input
                      type="text"
                      name="storePhone"
                      value="${store.storePhone}"
                      pattern="^(01[0-9]-?\d{3,4}-?\d{4}|0\d{1,2}-?\d{3,4}-?\d{4})$"
                      title="휴대폰(예: 010-1234-5678 또는 01012345678), 집전화(예: 02-123-4567 또는 021234567) 형식으로 입력하세요"
                      readonly
                    />
                  </div>
                  <!-- 이메일 -->
                  <div>
                    <input
                      type="email"
                      name="storeEmail"
                      value="${store.storeEmail}"
                      readonly
                      style="
                        text-align: center;
                        height: 30px;
                        outline: none;
                        width: 80%;
                        border: none;
                        font-size: 16px;
                      "
                    />
                  </div>
                  <!-- 액션 -->
                  <div class="actions" style="text-align: left">
                    <button type="button" class="btn btn-blue editBtn">
                      수정
                    </button>
                    <button
                      type="submit"
                      class="btn btn-blue saveBtn"
                      style="display: none"
                    >
                      저장
                    </button>
                    <button
                      type="button"
                      class="btn btn-red cancelBtn"
                      style="display: none"
                    >
                      취소
                    </button>
                  </div>
                </div>
              </form>
            </c:forEach>
          </div>

          <!-- /.sale-items -->
        </div>
        <!-- /.section-box -->

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

          <c:forEach
            var="i"
            begin="${paging.startPage}"
            end="${paging.endPage}"
          >
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

        <!-- 점포 등록 모달창  -->
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
              <input
                type="text"
                name="storePhone"
                required
                pattern="^(01[0-9]-?\d{3,4}-?\d{4}|0\d{1,2}-?\d{3,4}-?\d{4})$"
                title="휴대폰(예: 010-1234-5678 또는 01012345678), 집전화(예: 02-123-4567 또는 021234567) 형식으로 입력하세요"
              />

              <label>이메일</label>
              <input type="email" name="storeEmail" required />

              <div style="margin-top: 15px; text-align: right">
                <button type="submit" class="btn btn-blue">등록</button>
                <button type="button" id="closeModal" class="btn">닫기</button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </body>
  <script>
    const pwInput = document.getElementById("loginPw");
    const pwErrorMsg = document.getElementById("pwErrorMsg");

    pwInput.addEventListener("input", () => {
      const value = pwInput.value;
      const pattern = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*()_+=-]).{8,}$/;

      if (!pattern.test(value)) {
        pwErrorMsg.style.display = "block";
        pwErrorMsg.textContent =
          "비밀번호는 영문, 숫자, 특수문자를 포함하여 8자 이상이어야 합니다.";
      } else {
        pwErrorMsg.style.display = "none";
        pwErrorMsg.textContent = "";
      }
    });
    var CTX = "${pageContext.request.contextPath}";

    // 관리자 정보: 수정/적용 토글
    $(document).ready(function () {
      var adminEditMode = false;

      $("#adminEditBtn").on("click", function () {
        if (!adminEditMode) {
          // 읽기전용 해제 (adminId 제외)
          $("form[action='/admin/update']")
            .find("input")
            .each(function () {
              var name = $(this).attr("name");
              if (
                name !== "adminId" &&
                name !== "loginId" &&
                name !== "businessNumber"
              ) {
                $(this)
                  .prop("readonly", false)
                  .data("original-value", $(this).val());
              }
            });
          adminEditMode = true;
          $(this).val("적용하기");
        } else {
          // 폼 제출
          $("form[action='/admin/update']")[0].submit();
        }
      });
    });

    // 비밀번호 보이기/숨기기
    function togglePassword() {
      var pwField = document.getElementById("loginPw");
      var icon = document.getElementById("togglePwIcon");
      if (!pwField || !icon) return;

      if (pwField.type === "password") {
        pwField.type = "text";
        icon.src = CTX + "/static/images/eye-open.png";
        icon.alt = "숨기기";
      } else {
        pwField.type = "password";
        icon.src = CTX + "/static/images/eye-close.png";
        icon.alt = "보기";
      }
    }

    // 비밀번호 유효성 검사(한 번만 바인딩)
    (function attachPwValidation() {
      var pwInput = document.getElementById("loginPw");
      var pwErrorMsg = document.getElementById("pwErrorMsg");
      if (!pwInput || !pwErrorMsg) return;

      pwInput.addEventListener("input", function () {
        var value = pwInput.value;
        var pattern = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*()_+=-]).{8,}$/;
        if (!pattern.test(value)) {
          pwErrorMsg.style.display = "block";
          pwErrorMsg.textContent =
            "비밀번호는 영문, 숫자, 특수문자를 포함하여 8자 이상이어야 합니다.";
        } else {
          pwErrorMsg.style.display = "none";
          pwErrorMsg.textContent = "";
        }
      });
    })();

    // 점포 목록: 수정/취소
    // 수정
    $(document).on("click", ".editBtn", function () {
      var $form = $(this).closest(".store-form");

      // 수정 가능 필드만 해제
      $form
        .find(
          'input[name="storeName"], input[name="storeAddress"], input[name="storePhone"], input[name="storeEmail"]'
        )
        .each(function () {
          $(this)
            .prop("readonly", false)
            .css("cursor", "text") // 수정 모드: text 커서
            .data("original-value", $(this).val());
        });

      $form.find(".editBtn").hide();
      $form.find(".saveBtn, .cancelBtn").show();
    });

    // 취소
    $(document).on("click", ".cancelBtn", function () {
      var $form = $(this).closest(".store-form");

      $form
        .find(
          'input[name="storeName"], input[name="storeAddress"], input[name="storePhone"], input[name="storeEmail"]'
        )
        .each(function () {
          $(this)
            .val($(this).data("original-value") || "")
            .prop("readonly", true)
            .css("cursor", "pointer"); // 다시 pointer로 복원
        });

      $form.find(".saveBtn, .cancelBtn").hide();
      $form.find(".editBtn").show();
    });

    // 초기에는 모든 readonly 인풋 커서를 pointer로
    $(document).ready(function () {
      $("input[readonly]").css("cursor", "pointer");
    });
    // 행 클릭 하이라이트 + 선택 저장
    $(document).on("click", ".store-form .mypage-item", function (e) {
      if ($(e.target).closest(".actions").length) return;

      if (
        $(e.target).is("input, textarea, select") &&
        !$(e.target).prop("readonly")
      )
        return;

      $(".store-form .mypage-item > div:first-child").removeClass(
        "store-focus"
      );

      $(this).children("div:first-child").addClass("store-focus");

      var storeId = $(this)
        .closest(".store-form")
        .find('input[name="storeId"]')
        .val();
      if (storeId) {
        $.ajax({
          type: "POST",
          url: CTX + "/store/setSelectedStoreId",
          data: { storeId: storeId },
        });
      }
    });

    // 점포 등록 버튼 클릭 시 모달 열기
    $(".submit-btn").on("click", function () {
      $("#storeModal").css("display", "flex");
    });

    // 모달 닫기 버튼 클릭 시 모달 닫기
    $("#closeModal").on("click", function () {
      $("#storeModal").css("display", "none");
    });

    // 회원 탈퇴
    function submitDelete() {
      if (!confirm("정말 탈퇴하시겠습니까? 이 작업은 되돌릴 수 없습니다."))
        return;

      var form = document.createElement("form");
      form.method = "post";
      form.action = CTX + "/admin/delete";

      var input = document.createElement("input");
      input.type = "hidden";
      input.name = "adminId";
      input.value = "${sessionScope.loginedAdminDTO.adminId}";
      form.appendChild(input);

      document.body.appendChild(form);
      form.submit();
    }

    // 전역 노출 (HTML onclick에서 호출)
    window.togglePassword = togglePassword;
    window.submitDelete = submitDelete;
  </script>
  <script>
    // 1) iOS 자동줌/튀는 애니메이션 방지: 폼 컨트롤에 전부 16px + transition 제거
    function setBaseFormStyles(ctx = document) {
      const nodes = ctx.querySelectorAll("input, textarea, select, button");
      nodes.forEach((el) => {
        el.style.fontSize = "16px"; // iOS 확대 방지 핵심
        el.style.transition = "none"; // 눌렀을 때 커졌다/작아짐 제거
      });
    }
    setBaseFormStyles();

    // (선택) viewport 강제 설정 – 이미 meta가 있으면 갱신
    (function fixViewport() {
      let meta = document.querySelector('meta[name="viewport"]');
      if (!meta) {
        meta = document.createElement("meta");
        meta.name = "viewport";
        document.head.appendChild(meta);
      }
      // 확대 방지
      meta.content = "width=device-width, initial-scale=1, maximum-scale=1";
    })();

    // 2) readonly 입력들은 클릭해도 편집 안 되게 + 포인터 커서 + 보더/포커스 라인 제거
    function styleReadonlyInputs(ctx = document) {
      ctx
        .querySelectorAll(
          "input[readonly], textarea[readonly], select[readonly]"
        )
        .forEach((el) => {
          el.style.cursor = "pointer";
          el.style.pointerEvents = "none";
          el.style.userSelect = "none";
          el.style.webkitUserSelect = "none";
          el.style.caretColor = "transparent";
          el.style.outline = "none";
          el.style.boxShadow = "none";
          el.style.border = "none"; // 포커스 보더/라인 제거
        });
    }
    styleReadonlyInputs();

    // 3) 수정 버튼 누른 폼만 편집 가능하게(커서 text, 포인터 이벤트 활성화, 보더 그대로 none)
    //    기존 .editBtn / .cancelBtn 핸들러가 있다면 그대로 두고, 아래가 스타일만 보강
    document.addEventListener("click", function (e) {
      const editBtn = e.target.closest(".editBtn");
      if (editBtn) {
        const form = editBtn.closest(".store-form");
        if (!form) return;
        form
          .querySelectorAll(
            'input[name="storeName"], input[name="storeAddress"], input[name="storePhone"], input[name="storeEmail"]'
          )
          .forEach((el) => {
            el.readOnly = false;
            el.style.pointerEvents = "auto";
            el.style.cursor = "text"; // 편집 시 텍스트 커서
            el.style.border = "none"; // 포커스 보더 생기는 것 방지
            el.style.outline = "none";
            el.style.boxShadow = "none";
            el.style.fontSize = "16px";
          });
      }

      const cancelBtn = e.target.closest(".cancelBtn");
      if (cancelBtn) {
        const form = cancelBtn.closest(".store-form");
        if (!form) return;
        form
          .querySelectorAll(
            'input[name="storeName"], input[name="storeAddress"], input[name="storePhone"], input[name="storeEmail"]'
          )
          .forEach((el) => {
            el.readOnly = true;
            // 다시 읽기전용 스타일 복원
            el.style.cursor = "pointer";
            el.style.pointerEvents = "none";
            el.style.userSelect = "none";
            el.style.webkitUserSelect = "none";
            el.style.caretColor = "transparent";
            el.style.outline = "none";
            el.style.boxShadow = "none";
            el.style.border = "none";
            el.style.fontSize = "16px";
          });
      }
    });

    // 4) 동적으로 바뀐 readonly 속성도 자동 반영(감시)
    const roObserver = new MutationObserver((muts) => {
      muts.forEach((m) => {
        if (
          m.type === "attributes" &&
          m.attributeName === "readonly" &&
          m.target instanceof HTMLElement
        ) {
          const el = m.target;
          if (el.hasAttribute("readonly")) {
            // readonly로 바뀐 경우
            el.style.cursor = "pointer";
            el.style.pointerEvents = "none";
            el.style.userSelect = "none";
            el.style.webkitUserSelect = "none";
            el.style.caretColor = "transparent";
            el.style.outline = "none";
            el.style.boxShadow = "none";
            el.style.border = "none";
            el.style.fontSize = "16px";
          } else {
            // 편집 가능으로 바뀐 경우
            el.style.pointerEvents = "auto";
            el.style.cursor = "text";
            el.style.border = "none";
            el.style.outline = "none";
            el.style.boxShadow = "none";
            el.style.fontSize = "16px";
          }
        }
      });
    });
    document.querySelectorAll("input, textarea, select").forEach((el) => {
      roObserver.observe(el, { attributes: true });
    });
  </script>
</html>
