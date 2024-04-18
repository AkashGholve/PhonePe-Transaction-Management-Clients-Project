<!DOCTYPE html>
<html>
<head>
    <title>Upload Transaction PDF</title>
</head>
<body style="font-family: Arial, sans-serif; text-align: center; margin-top: 50px;">

    <h2 style="color: #333;">Upload Transaction PDF</h2>
    
    <form action="/upload" method="post" enctype="multipart/form-data" style="margin-top: 20px;">
        <label for="file" style="font-size: 16px; color: #666;">Choose a PDF file to upload:</label><br>
        <input type="file" name="file" id="file" accept=".pdf" style="margin-top: 10px; padding: 5px;"><br><br>
        <input type="submit" value="Upload" style="background-color: #007bff; color: #fff; border: none; padding: 10px 20px; cursor: pointer;">
    </form>

</body>
</html>
 
