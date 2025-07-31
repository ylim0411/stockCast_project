<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>index</title>
     <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.rtl.min.css" integrity="sha384-Xbg45MqvDIk1e563NLpGEulpX6AvL404DP+/iCgW9eFa2BqztiwTexswJo2jLMue" crossorigin="anonymous">
</head>
<body>
    <div class="accounting-Wrapper">
        <div class="accounting-header">
          <h1>회계 관리</h1>
        </div>
        <div class="caption">
          <input type="date" name="startDate"> ~
          <input type="date" name="endDate">
          <input type="text" name="orderNumber" placeholder="발주번호">
          <button onclick="onSearch()">검색</button>
          <button class="btn btn-primary" type="submit">Button</button>
        </div>
    </div>
</body>
<script>
  function onSearch(){

  };
</script>
</html>
