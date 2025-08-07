<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>save</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <style>
      body {
        position: relative;
        width: 100%;
        height: 100vh;
        margin: 0;
        padding: 0;
        background-color: #f5f5f5;
        font-family: "Arial", sans-serif;
      }

      .container {
        position: absolute;
        left: 50%;
        top: 50%;
        transform: translate(-50%, -50%);
        width: 400px;
        background-color: white;
        padding: 80px 50px;
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        display: flex;
        flex-direction: column;
        gap: 15px;
      }

      h2 {
        text-align: center;
        color: #333;
        margin-bottom: 30px;
      }

      form {
        display: flex;
        flex-direction: column;
        gap: 20px;
      }

      #check-result {
        position: absolute;
        bottom: 218px;
        margin: 0px;
        height: 20px;
        font-size: 12px;
        padding: 0 10px;
      }

      input[type="text"] {
        padding: 20px 10px;
        border: 1px solid #ccc;
        border-radius: 4px;
        font-size: 14px;
        resize: none;
        transition: border-color 0.2s;
      }

      /* 포커스 시 포인트 컬러 */
      .form-row input[type="text"]:focus:not([readonly]),
      .form-row textarea:focus {
        border-color: #007bff;
        outline: none;
      }

      input[type="submit"] {
        padding: 20px;
        font-size: 14px;
        cursor: pointer;
        border: none;
        border-radius: 4px;
        transition: 0.2s;
      }

      input[type="submit"] {
        background-color: #007bff;
        color: white;
      }

      input[type="submit"]:hover {
        background-color: #0056b3;
      }
      .error-msg {
        color: red;
        font-size: 12px;
        margin-top: 5px;
        position: relative;
        background: #fee;
        border: 1px solid red;
        padding: 5px 10px;
        border-radius: 4px;
        max-width: 300px;
      }

      .error-msg::before {
        content: "";
        position: absolute;
        top: -6px;
        left: 10px;
        border-width: 6px;
        border-style: solid;
        border-color: transparent transparent #fee transparent;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <h2>회원가입</h2>
      <form action="/admin/join" method="post">
        <input
          type="text"
          required
          name="adminName"
          placeholder="이름"
          value="${name}"
        />
        <input
          type="text"
          required
          name="loginId"
          placeholder="아이디"
          value="${email}"
        />
        <input
          id="loginPw"
          type="password"
          required
          name="loginPw"
          placeholder="비밀번호"
        />
        <div id="pwErrorMsg" class="error-msg" style="display: none"></div>
        <input
          type="text"
          required
          name="businessNumber"
          placeholder="사업자 등록번호"
        />
        <button
          type="button"
          id="businessCheck"
          onclick="businessNumberCheck()"
        >
          사업자 확인
        </button>
        <input type="submit" disabled id="submit" value="회원가입" />
      </form>
    </div>
    <script>
      // <c:if test="${not empty joinError}">alert('${joinError}')</c:if>;
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
      const businessNumberCheck = () => {
        const businessCheck = document.getElementById("businessCheck");
        const submit = document.getElementById("submit");
        const business = document.getElementsByName("businessNumber")[0];
        var data = {
          b_no: [business.value], // 사업자번호 "xxxxxxx" 로 조회 시,
        };

        console.log(business);

        $.ajax({
          url:
            "https://api.odcloud.kr/api/nts-businessman/v1/status?" +
            "serviceKey=ftwUy1klSytEIz3jnw%2BEAFkcdz%2FWOJJIyFpDS7Cs59ya60r%2F5gZhZ4QshIAo8arvTFxUdJjmjDRFrEw%2BSPaH9A%3D%3D", // serviceKey 값을 xxxxxx에 입력
          type: "POST",
          data: JSON.stringify(data), // json 을 string으로 변환하여 전송
          dataType: "JSON",
          contentType: "application/json",
          accept: "application/json",
          success: function (result) {
            console.log(result);
            if (!result.data[0].tax_type.includes("국세청")) {
              businessCheck.innerText = "인증 완료";
              businessCheck.disabled = true;
              business.readOnly = true;

              submit.disabled = false;
            }
          },
          error: function (result) {
            console.log(result.responseText); //responseText의 에러메세지 확인
          },
        });
      };
    </script>
  </body>
</html>
