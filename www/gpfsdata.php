<?php

$end = ( $_GET['end'] != '' && is_int(intval($_GET['end'])) ? intval($_GET['end']) : time() );
$start = ( $_GET['start'] != '' && is_int(intval($_GET['start'])) ? intval($_GET['start']) : intval($end - (30*60)) );

mysql_connect("db1", "usernamefordb", "passwordfordb") or die(mysql_error());
mysql_select_db("dbasename") or die(mysql_error());
$sth = mysql_query("SELECT * FROM (select time as timestamp, sum(br) as br, sum(bw) as bw, sum(rdc) as rdc, sum(wc) as wc, sum(dir) as dir, sum(iu) as iu from fsios where br != 0 and bw != 0 and timestamp >= $start and timestamp <= $end group by time order by 1 desc) q1 ORDER BY 1 asc;");
$rows = array();
while($r = mysql_fetch_assoc($sth)) {
    $rows[] = $r;
//    print $r['timestamp'] . "," . $r['br'] . PHP_EOL;
}
print json_encode($rows);

?>
