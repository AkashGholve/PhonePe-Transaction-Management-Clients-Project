<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Uploaded Files</title>
</head>
<body>
    <h2>Uploaded Files</h2>
    <ul>
        <c:forEach items="${uploadedFiles}" var="filename">
            <li><a href="/transactions/${filename}">${filename}</a></li>
        </c:forEach>
    </ul>
</body>
</html>

