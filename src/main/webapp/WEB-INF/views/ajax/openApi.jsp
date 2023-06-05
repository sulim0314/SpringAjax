<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>openApi.jsp</title>
<!-- CDN 참조-------------------------------------- -->
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<!-- jQuery library -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<!-- Latest compiled JavaScript -->
<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<!-- ------------------------------------------------- -->
<script type="text/javascript">
	$(function(){
		$('#search').click(function(){
			let keyword=$('input[name="book"]').val();
			if(!keyword){
				alert('검색어를 입력하세요');
				$('input[name="book"]').focus();
				return;
			}
			
			let url='openApiResult?query='+encodeURIComponent(keyword)+"&display=20&start=1";
			send(url,keyword, 1);			
			
		})//--------------
		
		
	})//$() end----------------	
	
	function send(url, keyword, cpage){
		$.ajax({
			type:'get',
			url:url,
			dataType:'json',
			cache:false
		}).done((res)=>{
			let total=res.total;//검색결과 도서 개수
			//alert(JSON.stringify(res));
			showList(res.items, total, keyword);
			showPage(total, keyword, 20, cpage);
		})
		.fail((err)=>{
			alert(err.status)
		})
	}//--------------------------------------
	
	function showList(items, total, keyword){
		let str='<h2 style="text-align:center"> '+keyword+" 검색 결과: "+total+"개</h2>";
			str+='<table class="table">';
			str+='<tr>';
			$.each(items, function(i, book){
				str+='<td width="20%" style="text-align:center">';
				str+='<a href="'+book.link+'">';
				str+='<img src="'+book.image+'" class="img img-thumbnail" width="140px">'
				str+='</a>';
				str+='<h4>'+book.title+'</h4>';
				str+='<h5>'+book.author+"</h5>";
				str+='</td>';
				if(i%5==4){
					str+='</tr><tr>'
				}
				
			})						
			str+='</tr>';
			str+='</table>'
			
		$('#result').html(str);
	}//-----------------------------
	
	function showPage(total, keyword, display, cpage){
		//if(total>200){
		//	total=200;
		//}
		//페이지수
		//pageCount=(total-1)/display+1 <==자바 int/int+int => 정수형
		//let pageCount=Math.floor((total-1)/display+1);//<==자바스크립트 실수형
		let pageCount=Math.ceil(total/display);
		//alert(pageCount);
		/*
		i==cpage   	display		start
		1			20			1
		2			20			21
		3			20			41
		...
		
		start = (i-1)*display+1
		*/
		let pageBlock=10;
		let prevBlock=Math.floor((cpage-1)/pageBlock)*pageBlock;//이전 블럭 (이전 10개)
		let nextBlock=prevBlock+(pageBlock+1);
		console.log('pageCount: '+pageCount+", prevBlock: "+prevBlock+", nextBlock: "+nextBlock);
		
		let str='<ul class="pagination">';
		
		
		if(prevBlock>0){	
			let start=(prevBlock-1)*display+1;
			str+='<li>';
			str+='<a href="#" onclick="fetch(\''+ keyword+'\','+start+','+prevBlock+')">';
			str+='Prev';			
			str+='</a>'
			str+='</li>'
		}//if-------------------
		//for(let i=1;i<=pageCount;i++){	
		for(let i=prevBlock+1;i<=nextBlock-1 && i<=pageCount; i++){	
			let start=(i-1)*display+1;			
			str+='<li>';
			str+='<a href="#" onclick="fetch(\''+ keyword+'\','+start+','+i+')">';
			str+=i;			
			str+='</a>'
			str+='</li>'
			
		}//for------
		
		if(nextBlock<=pageCount){	
			let start=(nextBlock-1)*display+1;
			str+='<li>';
			str+='<a href="#" onclick="fetch(\''+ keyword+'\','+start+','+nextBlock+')">';
			str+='Next';			
			str+='</a>'
			str+='</li>'
		}//if-------------------
		
		str+='</ul>';
		$('#paging').html(str);
		
	}//------------------------------
	
	function fetch(query, start, cpage){
		//alert(query+"/"+start+"/"+cpage);
		let url='openApiResult?query='+encodeURIComponent(query)+"&display=20&start="+start;
		send(url,query,cpage);
	}//----------------------------------------
	
	function test(){
		//자바스크립트 cors 정책에 위배되어 네트워크 통신 불가능
		//==> 대신 자바로 네이버에 요청을 보내보자. BookNaverProxy.java
		let url='https://openapi.naver.com/v1/search/book.json?query=Ajax';
		$.ajax({
			type:'GET',
			url:url,
			dataType:'json',
			cache:false,
			headers:{
				'X-Naver-Client-Id':'Fqk6lvma85ULEJC2dNpn',
				'X-Naver-Client-Secret':'9BaxBij80p'
			}
		})
		.done((res)=>{
			alert(res)
		})
		.fail((res)=>{
			alert('error: '+res.status+", message: "+res.responseText)
		})
	}
	
</script>
<style>
	#msg, #paging,#result{
		margin:7px;
		padding:7px;		
	}
	#paging{
		width:60%;
		margin:auto;		
		text-align:center;
	}
</style>
</head>
<body>
<div class="section">
	<div class="container">
		<h1 style="text-align:center;margin:1em">Naver Open Api Book</h1>
		
		<div class='row'>
			<div class="col-md-1 col-md-offset-1">
				<label>도서검색</label>
			</div>
			<div class="col-md-8">
				<input type="text" name="book" class="form-control">
			</div>
			<div class="col-md-2">
				<button id="search" class="btn btn-primary">검색</button>
			</div>
		</div>
		
		<div id="msg"></div>
		<div id="paging"></div>
		<div id="result"></div>
	</div>
</div>
</body>
</html>





