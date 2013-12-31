<html>
<head>
    <title>%($pageTitle%)</title>
    <link rel="shortcut icon" href="/favicon.ico?v=2" />
    <link rel="stylesheet" type="text/css" href="/pub/style.css" />
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"> 
% if(! ~ $#meta_description 0)
%   echo '    <meta name="description" content="'$"meta_description'">'
% if(! ~ $#meta_keywords 0)
%   echo '    <meta name="keywords" content="'$"meta_keywords'">'
</head>
<body>

