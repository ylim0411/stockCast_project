<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>login</title>
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
        gap: 15px;
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
    </style>
  </head>
  <body>
    <div class="container">
      <h2>로그인</h2>
      <form action="/admin/login" method="post">
        <input type="text" name="loginId" placeholder="아이디" />
        <input type="text" name="loginPw" placeholder="비밀번호" />

        <input type="submit" value="로그인" class="btn" />
      </form>
    </div>
  </body>
</html>
