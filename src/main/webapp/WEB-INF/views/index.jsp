<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>StockCast Login</title>
    <link rel="icon" href="${pageContext.request.contextPath}/static/images/favicon.png" type="image/png" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css" />
  </head>
  <body>
    <div class="Desktop" style="background-image: url('${pageContext.request.contextPath}/static/images/desktop.png')">
      <ul class="difultImg">
        <li>
          <img src="${pageContext.request.contextPath}/static/images/pcIcon.png" alt="pcIcon" />
          <span>PC</span>
        </li>
        <li>
          <img src="${pageContext.request.contextPath}/static/images/printerIcon.png" alt="printerIcon" />
          <span>프린터</span>
        </li>
        <li>
          <img src="${pageContext.request.contextPath}/static/images/emptyIcon.png" alt="emptyIcon" />
          <span>휴지통</span>
        </li>
        <li>
          <img src="${pageContext.request.contextPath}/static/images/folderIcon.png" alt="folderIcon" />
          <span>파일</span>
        </li>
        <li>
          <img src="${pageContext.request.contextPath}/static/images/chromeIcon.png" alt="chromeIcon" />
          <span>chrome</span>
        </li>
      </ul>
      <div class="StockCast">
        <a href="/admin/login">
          <img src="${pageContext.request.contextPath}/static/images/StockCast.png" alt="StockCast" />
        </a>
        <span>StockCast</span>
      </div>
    </div>
  </body>
</html>
