<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>save</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
     <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css" />
  </head>
  <body>
    <div class="container">
      <div class="join-container">
        <div class="logo">
          <img src="${pageContext.request.contextPath}/static/images/logo-b.png" alt="logo" />
        </div>
        <div class="join-text">
          <form action="/admin/join" method="post">
            <input type="text" required name="adminName" placeholder="이름" value="${name}" />
            <input type="text" required name="loginId" placeholder="아이디" value="${email}" />
            <input id="loginPw" type="password" required name="loginPw" placeholder="비밀번호" />
            <p id="pwErrorMsg" class="error-msg" style="display:none"></p>
            <div style="display: flex; justify-content: space-between;">
            <input type="number" required name="businessNumber" placeholder="사업자 등록번호" style="width: 68%; margin-top: 5px;"/>
            <button type="button" id="businessCheck" onclick="businessNumberCheck()" class="btn submit-btn" style="width: 30%; height: 52px; margin-top: 5px;">사업자 확인</button>
            </div>
            <input type="submit" disabled id="submit" value="회원가입"  class="btn submit-btn" />
          </form>
          
      </div>
    </div>
  </div>
    <script>
      // <c:if test="${not empty joinError}">alert('${joinError}')</c:if>;
      const pwInput = document.getElementById('loginPw');
      const pwErrorMsg = document.getElementById('pwErrorMsg');

      pwInput.addEventListener('input', () => {
        const value = pwInput.value;
        const pattern = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*()_+=-]).{8,}$/;

        if (!pattern.test(value)) {
          pwErrorMsg.style.display = 'block';
          pwErrorMsg.textContent = '비밀번호는 영문, 숫자, 특수문자를 포함하여 8자 이상이어야 합니다.';
        } else {
          pwErrorMsg.style.display = 'none';
          pwErrorMsg.textContent = '';
        }
      });
      const businessNumberCheck = () => {
        const businessCheck = document.getElementById('businessCheck');
        const submit = document.getElementById('submit');
        const business = document.getElementsByName('businessNumber')[0];
        var data = {
          b_no: [business.value], // 사업자번호 "xxxxxxx" 로 조회 시,
        };

        console.log(business);

        $.ajax({
          url:
            'https://api.odcloud.kr/api/nts-businessman/v1/status?' +
            'serviceKey=ftwUy1klSytEIz3jnw%2BEAFkcdz%2FWOJJIyFpDS7Cs59ya60r%2F5gZhZ4QshIAo8arvTFxUdJjmjDRFrEw%2BSPaH9A%3D%3D', // serviceKey 값을 xxxxxx에 입력
          type: 'POST',
          data: JSON.stringify(data), // json 을 string으로 변환하여 전송
          dataType: 'JSON',
          contentType: 'application/json',
          accept: 'application/json',
          success: function (result) {
            console.log(result);
            if (!result.data[0].tax_type.includes('국세청')) {
              businessCheck.innerText = '인증 완료';
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
