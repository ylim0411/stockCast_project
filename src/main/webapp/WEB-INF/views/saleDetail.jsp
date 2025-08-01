<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ include
file="/WEB-INF/views/header.jsp" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>거래명세서</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/static/css/style.css"
    />
  </head>
  <body>
    <div class="title-box">
      <p class="sub-title">매출 관리</p>
      <h2 class="title">거래명세서</h2>
    </div>
    <div class="container">
      <!DOCTYPE html>
      <html lang="ko">
        <head>
          <meta charset="UTF-8" />
          <meta
            name="viewport"
            content="width=device-width, initial-scale=1.0"
          />
          <title>거래명세서</title>
          <link rel="stylesheet" href="style.css" />
        </head>
        <body>
          <div>
            <div class="dateil-header">
              <div>
                박스
              </div>
              <table class="deteil-table">
                <tr>
                  <th colspan="5">거래명세서</th>
                </tr>
                <tr>
                  <th rowspan="3">공급자용</th>
                  <td>사업자등록번호</td>
                  <td>00-000-0000</td>
                  <td>TEL</td>
                  <td>000-0000-0000</td>
                </tr>
                <tr>
                  <td>상호</td>
                  <td>나뚜루</td>
                  <td>성명</td>
                  <td>홍길동</td>
                </tr>
                <tr>
                  <td>주소</td>
                  <td colspan="3">서울시 관악구</td>
                </tr>
              </table>
            </div>
            <div>
              입금 계좌번호 : 933502 - 00 - 541827 (국민-예금주 : 이카플레이스)
            </div>
            <table>
              <thead>
                <tr>
                  <th>일자</th>
                  <th>품목명[규격]</th>
                  <th>수량</th>
                  <th>단가</th>
                  <th>공급가액</th>
                  <th>부가세</th>
                  <th>적요</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>09/21</td>
                  <td>전륜에어스트럿壹[EA]</td>
                  <td>10</td>
                  <td>10,000</td>
                  <td>100,000</td>
                  <td>10,000</td>
                  <td>9.25 세미테크 제천공장</td>
                </tr>
                <tr>
                  <td>09/21</td>
                  <td>후륜에어스프링[EA]</td>
                  <td>20</td>
                  <td>30,000</td>
                  <td>600,000</td>
                  <td>60,000</td>
                  <td>9.25 세미테크 제천공장</td>
                </tr>
                <tr>
                  <td>09/21</td>
                  <td>에어탱크 부품[EA]</td>
                  <td>10</td>
                  <td>50,000</td>
                  <td>500,000</td>
                  <td>50,000</td>
                  <td>9.25 세미테크 제천공장</td>
                </tr>
                <tr>
                  <td>09/21</td>
                  <td>에어탱크 부품.J2[EA]</td>
                  <td>10</td>
                  <td>55,000</td>
                  <td>550,000</td>
                  <td>55,000</td>
                  <td>9.25 세미테크 제천공장</td>
                </tr>
              </tbody>
              <tfoot>
                <tr>
                  <td>수량</td>
                  <td>50</td>
                  <td>공급가액</td>
                  <td>1,750,000</td>
                  <td>VAT</td>
                  <td>175,000</td>
                  <td>합계</td>
                  <td>1,925,000</td>
                  <td>인수</td>
                  <td></td>
                </tr>
              </tfoot>
            </table>
          </div>
        </body>
      </html>
    </div>
  </body>
</html>
