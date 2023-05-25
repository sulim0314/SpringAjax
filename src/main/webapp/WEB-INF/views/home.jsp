<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<html>
<head>
<title>Home</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<script
	src="https://cdn.jsdelivr.net/npm/jquery@3.6.1/dist/jquery.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
  	$(function(){
  		$('#btn1').click(()=>{
  			let url='ajaxVO?num=100&name=이영희';
  			$.ajax({
  				url:url,
  				type:'get',
  				dataType:'json', //응답유형
  				cache:false,
  				success:function(res){
  					//JSON.stringify():json객체를 문자열로 직렬화해서 반환 
  					//<=> JSON.parse(): 문자열(json형태문자열)을 파싱해서 json객체로 반환
  					//alert(JSON.stringify(res));
  					//json객체 1개가 오는 경우
  					//alert(res.name);
  					let str='<h3>Num: '+res.num+"</h3>";
  						str+='<h3>Name: '+res.name+"</h3>";
  						str+='<h3>Tel : '+res.tel+"</h3>";
  						str+='<h3>Address: '+res.addr+'</h3>';
  					$('#result').html(str);
  				},
  				error:function(err){
  					alert('err: '+err.status+"/"+err.responseText)
  				}
  			})
  		})//---------------
  		//요청방식:post, url:ajaxList, data:num=300&name=김철수,응답유형:json
  		//파라미터 데이터를 보내면, 스프링에서는 @RequestParam 또는 @ModelAttribute로 받는다
  		//그런데 파라미터를 json유형으로 보내면 다르다 @RequestBody를 붙이고 VO객체로 받는다
  		$('#btn2').click(()=>{
  			$.ajax({
  				type:'post',
  				url:'ajaxList',
  				data:'num=300&name=김철수',
  				dataType:'json',
  				cache:false,
  				success:function(res){
  					//alert(JSON.stringify(res));
  					//$.each(배열,function(i,item){})
  					let str='<ul>';
  					$.each(res, (i, user)=>{
  						console.log(i+"/"+user.name);
  						str+='<li>'+user.num+", "+user.name+", "+user.tel+", "+user.addr+"</li>";
  					})
  					str+='</ul>';
  					$('#result').html(str);			
  				},
  				error:function(err){
  					alert(err.status);
  				}
  			})
  		})//---------------
  		//post방식. 파라미터 데이터를 json객체로 보낼 경우
  		$('#btn3').on('click',()=>{
  			let jsonData={
  					num:500,
  					name:'김수지',
  					tel:'3333',
  					addr:'인천'
  			}
  			//json데이터를 보내고 응답도 json으로 받아보자
  			$.ajax({
  				type:'post',
  				url:'ajaxJsonParam',
  				contentType:'application/json', //컨텐트타입 지정에 유의하자
  				data:JSON.stringify(jsonData),//json객체를 문자열로 직렬화해서 보내자
  				dataType:'json',
  				cache:false
  			}).done(function(res){
  				//alert(res)
  				let str='';
  				for(let i=0;i<res.length;i++){
  					let user=res[i];
  					str+='<h3>'+user.num+', '+user.name+','+user.tel+','+user.addr+'</h3>';	
  				}
  				$('#result').html(str);
  			})
  			  .fail(function(err){
  				  alert(err.status)
  			  })
  			
  		})//--------------------------
  		
  		//ajax로 파일업로드 처리 -post
  		$('#frm').submit((e)=>{
  			e.preventDefault();
  			//첨부파일명을 알아보자
  			let file=$('#filename')[0]
  			console.dir(file.files);
  			if(file.files.length==0){
  				alert('첨부파일을 선택하세요');
  				return;
  			}
  			//post방식으로 파일을 첨부해서 보낼때는 파라미터 데이터들을 FormData에 담아서 보내야 한다.
  			let frmData=new FormData();
  			frmData.append('name',$('#name').val())
  			frmData.append('msg',$('#msg').val())
  			frmData.append('filename',file.files[0])
  			//alert(JSON.stringify(frmData))
  			//post, ajaxFile
  			$.ajax({
  				type:'post',
  				url:'ajaxFile',
  				data:frmData,
  				contentType:false,//multipart/form-data 로 보내려면 false로 지정해야 한다
  				processData:false//기본값: true=>데이터를 쿼리스트링으로 변환해서 전송한다는 의미
  			}).done((res)=>{
  				//alert(JSON.stringify(res))
  				if(res.result=='OK'){
  					let str='<div class="alert alert-success">';
  						str+='<h3>'+res.filename+"파일 업로드 성공</h3>";
  						str+='</div>';
  					$('#result').html(str);
  				}
  				
  			}).fail((err)=>{
  				alert(err.status)
  			})
  		})//----------------------
  		
  		
  	})//$() end--------------
  </script>
</head>
<body>
	<div class='container'>
		<h1>Hello Ajax!</h1>

		<P>
			<a href='ajaxView'>Pizza Order</a>
		<hr>
		<button id="btn1">ajax(VO)-json</button>
		<button id='btn2'>ajax(List)-json(기존 파라미터 형식으로 데이터 보내기)</button>
		<button id='btn3'>ajax(List)-json(json형태의 파라미터 데이터 보내기)</button>
		<hr>
		<h3>Ajax 파일 업로드</h3>
		<form id="frm" method="post" enctype="multipart/form-data">
			올린이:<input type="text" name="name" id="name"><br><br> 
			메시지:<input	type="text" name="msg" id="msg"><br><br> 
			첨부파일:<input type="file" name="filename" id="filename"><br><br>
			<button class='btn btn-primary'>업로드</button>
		</form>
		<hr>
		<div id='result'></div>
		</P>
	</div>
</body>
</html>
