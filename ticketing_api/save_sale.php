<?php
header('Content-Type: application/json');
include "db.php";

$numberofticket = (int)$_POST['numberofticket'];
$totalprice = (double)$_POST['totalprice'];
$id =(int)$_POST['id'];


$stmt = $db->prepare("INSERT INTO sale VALUES(?, ?, now(), ?)");
$stmt->execute([$numberofticket, $totalprice, $id]);

$result = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo json_encode($result);