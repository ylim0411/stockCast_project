  $(function () {
        // 메인 메뉴 클릭 시
        $("li.main-menu > a").on("click", function (e) {
			// 페이지이동 방지
          e.preventDefault();

          const $clickedMenu = $(this).parent(); // li.main-menu
          const $subMenu = $clickedMenu.find(".sub-menu");

          // 현재 열려있는 다른 메뉴 닫기
          $("li.main-menu")
            .not($clickedMenu)
            .removeClass("on")
            .find(".sub-menu")
            .slideUp()
            .find("li")
            .removeClass("on");

          // 현재 클릭한 메뉴 toggle
          const isOpen = $clickedMenu.hasClass("on");
          if (isOpen) {
            // 열려 있으면 닫기
            $clickedMenu.removeClass("on");
            $subMenu.slideUp();
          } else {
            // 닫혀 있으면 열기
            $clickedMenu.addClass("on");
            $subMenu.slideDown();

            // 하위 첫 번째 서브 메뉴 항목을 활성화
            const $firstSubItem = $subMenu.find("li").first();
            $(".sub-menu li").removeClass("on"); // 전체 초기화
            $firstSubItem.addClass("on");
          }
        });

        // 서브 메뉴 클릭 시 활성화
        $(".sub-menu li a").on("click", function (e) {
          e.preventDefault();

          $(".sub-menu li").removeClass("on"); // 전체 비활성화
          $(this).parent().addClass("on"); // 클릭된 항목 활성화
        });
      });
