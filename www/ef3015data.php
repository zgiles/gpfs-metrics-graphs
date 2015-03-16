<?php
// Modify the db connect string below

$end = ( $_GET['end'] != '' && is_int(intval($_GET['end'])) ? intval($_GET['end']) : time() );
$start = ( $_GET['start'] != '' && is_int(intval($_GET['start'])) ? intval($_GET['start']) : intval($end - (30*60)) );
// timestamp >= $start and timestamp <= $end

mysql_connect("db1", "usernamefordb", "passwordfordb") or die(mysql_error()); 
mysql_select_db("dbasename") or die(mysql_error());
$sth = mysql_query("SELECT * FROM (select timestamp, sum(bps) as bps, sum(iops) as iops from ef3015_blockstats where devid like 'vol%' and timestamp >= $start and timestamp <= $end group by timestamp order by 1 desc) q1 ORDER BY 1 asc;");
$rows = array();
while($r = mysql_fetch_assoc($sth)) {
    $rows[] = $r;
//    print $r['timestamp'] . "," . $r['br'] . PHP_EOL;
}
print json_encode($rows);

?>
