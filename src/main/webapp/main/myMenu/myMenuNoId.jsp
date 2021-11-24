<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<link rel="stylesheet" href="css/myMenu.css">   
    
<div class="myMenu">

	<div class="backBtn"><img src="image/backicon.PNG"></div>
	<div class="contentsdiv">
		
		<div class="spandiv">
			<div><a href="#">로그인</a>
				<div class="loginDiv hid">
					<form name="memberLoginForm" id="memberLoginForm" method="post">
						<table>
							<tr>
								<td>아이디</td>
								<td>
									<input type="text" name="id" id="id" placeholder="아이디 입력">
									<div id= "idDiv"></div>
								</td>
							</tr>
							<tr>
								<td>비밀번호</td>
								<td>
									<input type="password" name="pwd" id="pwd" placeholder="비밀번호 입력">
									<div id= "pwdDiv"></div>
								</td>
							</tr>
							<tr>
								<td colspan="2" align="center">
									<input type="button" id="memberLoginBtn" value="로그인">
									<input type="button" id="memberWriteFormBtn" value="회원가입">
								</td>
							</tr>
						</table>
					</form>
				</div>
			</div>
			<div><a href="#">고객센터</a></div>
		</div>
	</div>	

	
</div>