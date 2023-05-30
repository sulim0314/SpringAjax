<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
   
<!DOCTYPE html>
<html>
<head>  
<title>BOOK</title>
<!-- CDN 참조-------------------------------------- -->
<link rel="stylesheet"
	href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
<script
	src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
<!-- ------------------------------------------------- -->
<style type="text/css">
select{
	padding:5px;
}
#sel, #sel2{
   margin:5px;
}
#lst1{
	position:relative;
	width:500px;
	margin:0px;
	border:1px solid silver;
	background:#efefef;
	color:blue;
	left:0px;
}
#lst2{
	margin:0;
	padding:2px;
}
#lst2 ul li{
	list-style:none;
}


</style>


<script type="text/javascript">
	$(function(){
		//모든 도서 목록 가져오기
		getAllBook();
	});
	
	//GET  /books :모든 도서정보가져오기
	//GET  /books?keyword=도서명 : 검색한 도서정보 가져오기
	//GET  /books/isbn번호 : 특정 도서정보 가져오기
	//POST /books : 도서정보 등록
	//PUT  /books/isbn번호 : 특정 도서정보 수정하기
	//DELETE /books/isbn번호 : 특정 도서정보 삭제하기
	
	const getPublish=function(){
		$.ajax({
			type:'get',
			url:'publishList',
			dataType:'json',
			cache:false
		})
		.done((res)=>{
			//alert(JSON.stringify(res))
			showSelect(res);
		})
		.fail((err)=>{
			alert(err.status);
		})
	}//--------------------------
	
	const showSelect=function(data){
		let str='<select name="publish" onchange="getTitleByPub(this.value)">';
		str+='<option value="">::출판사 목록:::</option>';
		$.each(data,(i, book)=>{		
			str+='<option value="'+book.publish+'">';
			str+=book.publish;
			str+='</option>'
		});	
			
			str+='</select>';
			
			$('#sel').html(str);
	}//----------------------------
	
	const getTitleByPub=function(pub){
		//alert(pub);
		$.ajax({
			type:'get',
			url:'titleList?publish='+pub,
			dataType:'json',
			cache:false
		})
		.done((res)=>{
			showSelect2(res);
		})
		.fail((err)=>{
			alert(err.status);
		})
		
	}//--------------------------------
	const showSelect2=function(data){
		let str='<select name="publishTitle" onchange="bookInfo(this.value)">';
		str+='<option value="">::도 서 명:::</option>';
		$.each(data,(i, book)=>{		
			str+='<option value="'+book.title+'">';
			str+=book.title;
			str+='</option>'
		});	
			
			str+='</select>';
			
			$('#sel2').html(str);
	}//----------------------------
	
	const bookInfo=function(vtitle){
		
		if(!vtitle){
			vtitle=$('#books').val();//키워드 입력값 가져오기
			if(!vtitle){
				alert('검색어를 입력하세요');
				$('#books').focus();
				return;
			}			
		}
		console.log('vtitle: '+vtitle);
		//alert(encodeURIComponent(vtitle))
		$.ajax({
			type:'get',
			url:'books?keyword='+encodeURIComponent(vtitle),
			dataType:'json',
			cache:false
		})
		.done((res)=>{
			//alert(JSON.stringify(res))
			showBooks(res);
			if(res.length>0){
				showBookInfo(res[0])
			}else{
				clearBookInfo();
			}
		})
		.fail((err)=>{
			alert(err.status)
		})
		
	}//--------------------------------
	
	
	const goDel=function(visbn){
		//alert(visbn);
		let url="books/"+visbn;
		$.ajax({
			type:'delete',
			url:url,
			dataType:'json',
			cache:false,
			success:function(res){
				//alert(res);//'{result:OK}'
				if(res.result=='OK'){
					getAllBook();
				}else{
					alert('도서 정보 삭제 실패');
				}
			},
			error:function(err){
				alert(err.status);
			}
		})		
	}//----------------------------
	//도서정보 수정처리
	const goEditEnd=function(){			
		let bn=$('#isbn').val()
		let btitle=$('#title').val();
		let pub=$('#publish').val();
		let price=$('#price').val();
		//let pdate=$('#published').val();
		let jsonData={
				isbn:bn,
				title:btitle,
				publish:pub,
				price:price				
		};
		//alert(JSON.stringify(jsonData))
		$.ajax({
			type:'put',
			url:'books/'+bn,
			data:JSON.stringify(jsonData),
			contentType:'application/json; charset=UTF-8',
			dataType:'json',
			cache:false,
			success:function(res){
				//alert(res);//{result:'OK'}
				if(res.result=='OK'){
					getAllBook()
				}else{
					alert('도서 정보 수정 실패');
				}
			},
			error:function(err){
				alert(err.status);		
			}
		})
	}//---------------------------------
	//도서정보 보여주기
	const goEdit=function(visbn){
		//alert(visbn);
		$.ajax({
			type:'get',
			url:'books/'+visbn,
			dataType:'json',
			success:function(res){
				//alert(JSON.stringify(res))
				showBookInfo(res);
			},
			error:function(err){
				alert(err.status);
			}
		})
	}//----------------------------
	const clearBookInfo=function(){
		$('#isbn').val("");
		$('#title').val("");
		$('#publish').val("");
		$('#price').val("");
		$('#published').val("");					
		$('#bimage').html("");
	}//-----------------------------
	const showBookInfo=function(res){
		$('#isbn').val(res.isbn);
		$('#title').val(res.title);
		$('#publish').val(res.publish);
		$('#price').val(res.price);
		$('#published').val(res.published);
		let str='<img src="resources/Upload/'+res.bimage+'" class="img img-thumbnail">'				
		$('#bimage').html(str);
	}//---------------------------------
	const getAllBook=function(){
		$.ajax({
			type:'get',
			url:'/books',
			dataType:'json',
			success:function(res){
				//alert(JSON.stringify(res))
				showBooks(res);
			},
			error:function(err){
				alert(err.status)
			}
		})
	}//-----------------------------
	const showBooks=function(res){
		let str='<table class="table table-bordered">';
		$.each(res, (i, book)=>{
			str+='<tr>';
			str+='<td width="20%">';
			str+=book.title;
			str+='</td>';
			
			str+='<td width="20%">';
			str+=book.publish;
			str+='</td>';
			
			str+='<td width="20%">';
			str+=book.price;
			str+='</td>';
			
			str+='<td width="20%">';
			str+=book.published;
			str+='</td>';
			
			str+='<td width="20%" style="text-align:center">';
			str+='<a href="#book_data" onclick="goEdit(\''+book.isbn+'\')">수정</a> | ';			
			str+='<a href="#book_data" onclick="goDel(\''+book.isbn+'\')">삭제</a>';
			str+='</td>';

			str+='</tr>';
		    })
			str+='</table>';
		$('#book_data').html(str);
	}//-------------------------------
	//검색어 자동완성
	const autoComp=function(val){
		//console.log('val: '+val);
		$.ajax({
			type:'post',
			url:'autoComp',
			data:'keyword='+val,
			dataType:'json',
			cache:false			
		})
		.done((res)=>{
			console.log(JSON.stringify(res))
			let str='<ul>';
			$.each(res, function(i, title){
				str+='<li><a href="#" onclick="setting(\''+title+'\')">';
				str+=title;
				str+='</li>';
			})			
			str+='</ul>';
			$('#lst2').html(str).show('slow');
			$('#lst1').show('slow')
		})
		.fail((err)=>{
			alert(err.status);
		})
	}//--------------------------------
	
	const setting=function(val){
		$('#books').val(val);
		$('#lst2').hide();
		$('#lst1').hide();
	}//--------------------------------
</script>
</head>
<!--onload시 출판사 목록 가져오기  -->
<body onload="getPublish()">
   <div class="container">
	<h2 id="msg">${msg}</h2>
<form name="findF" id="findF" role="form"
 action="" method="POST">
<div class="form-group">
<label for="sel" class="control-label col-sm-2">출판사</label>
<span id="sel"></span><span id="sel2"></span>
</div>
<p>
<div class='form-group'>
	<label for="books" class="control-label col-sm-2" id="msg1">도서검색</label>
	<div class="col-sm-6">
	
	<input type="text" name="books" id="books"	 onkeyup="autoComp(this.value)"	 class="form-control" >
	
	 <!-- ---------------------------- -->
	 <div id="lst1" class="listbox"	 style="display:none">
	 	<div id="lst2" class="blist" style="display:none">
	 	</div>
	 </div>
	 <!-- ---------------------------- -->
	</div>
</div>
</form>
<div>
 
 <button type="button"  onclick="bookInfo('')"  class="btn btn-primary">검색</button>
 
 <button type="button" onclick="getAllBook()" class="btn btn-success">모두보기</button>
 <button type="button" id="openBtn"
  class="btn btn-info">OPEN API에서 검색</button><br><br>
</div>
<div id="localBook">

<div id="publishList">

</div>

<table class="table table-bordered" border="1" style='margin-bottom:0'>
	<tr class="info">
		<td style="width:20%;">서명</td>
		<td style="width:20%;">출판사</td>
		<td style="width:20%;">가격</td>
		<td style="width:20%;">출판일</td>
		<td style="width:20%;">편집</td>
	</tr>
</table>
<!-- ----------------------- -->
<div id="book_data"></div>
<!-- ----------------------- -->
<form id="editF" name="editF">
<table id="book_info" class="table table-hover" border="2">
	<tr>
		<td width="20%">ISBN코드</td>
		<td>
		<input type="text" name="isbn" id="isbn"
		class="form-control" readonly>
		</td>
		<td rowspan="6" width="30%" id="bimage" class="text-center"></td>
	</tr>
	<tr>
		<td>서명</td>
		<td>
		<input type="text" name="title" id="title"
		class="form-control">
		</td>
		
	</tr>
	<tr>
		
		<td>출판사</td>
		<td>
		<input type="text" name="publish" id="publish"
		class="form-control">
		</td>
		
	
	</tr>
	<tr>
	
		<td>가격</td>
		<td>
		<input type="text" name="price" id="price"
		class="form-control">
		</td>
		
	</tr>
	<tr>
	
		<td>출판일</td>
		<td>
		<input type="text" name="published"
		 id="published"  disabled
		class="form-control">
		</td>
		
	</tr>
	<tr>
		<td colspan="2">
		<button type="button"
		onclick="goEditEnd()" class="btn btn-danger">수정</button></td>
	</tr>
</table>
</form>
	</div>
</div><!-- #localBook end -->

<!-- ------------------------------- -->
<div id="openApiBook">

</div>
	
</body>
</html>

<!-- https://apis.daum.net/search/book -->
<!-- 53c73f32f6c4150ca5aa184ba6250d8e -->

<!-- https://apis.daum.net/search/book?apikey=53c73f32f6c4150ca5aa184ba6250d8e&q=다음카카오&output=json -->




