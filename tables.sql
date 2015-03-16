CREATE DATABASE `gpfs_stats` /*!40100 DEFAULT CHARACTER SET latin1 */;

CREATE TABLE `ef3015_blockstats` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `timestamp` int(10) unsigned NOT NULL,
  `time` int(10) unsigned NOT NULL,
  `devid` varchar(255) NOT NULL,
  `serial` varchar(255) NOT NULL,
  `bps` bigint(20) unsigned NOT NULL,
  `iops` bigint(20) unsigned NOT NULL,
  `numreads` bigint(20) unsigned NOT NULL,
  `numwrites` bigint(20) unsigned NOT NULL,
  `dataread` bigint(20) unsigned NOT NULL,
  `datawritten` bigint(20) unsigned NOT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `ef3015_controllers` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `timestamp` int(10) unsigned NOT NULL,
  `time` int(10) unsigned NOT NULL,
  `devid` varchar(255) NOT NULL,
  `cpuload` int(10) unsigned NOT NULL,
  `uptime` bigint(20) unsigned NOT NULL,
  `bps` bigint(20) unsigned NOT NULL,
  `iops` bigint(20) unsigned NOT NULL,
  `numreads` bigint(20) unsigned NOT NULL,
  `numwrites` bigint(20) unsigned NOT NULL,
  `dataread` bigint(20) unsigned NOT NULL,
  `datawritten` bigint(20) unsigned NOT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `ef3015_hostports` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `timestamp` int(10) unsigned NOT NULL,
  `time` int(10) unsigned NOT NULL,
  `devid` varchar(255) NOT NULL,
  `bps` bigint(20) unsigned NOT NULL,
  `iops` bigint(20) unsigned NOT NULL,
  `numreads` bigint(20) unsigned NOT NULL,
  `numwrites` bigint(20) unsigned NOT NULL,
  `dataread` bigint(20) unsigned NOT NULL,
  `datawritten` bigint(20) unsigned NOT NULL,
  `queuedepth` bigint(20) unsigned NOT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `fsios` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `fs` varchar(255) NOT NULL,
  `node` varchar(255) NOT NULL,
  `timestamp` int(10) unsigned NOT NULL,
  `time` int(10) unsigned NOT NULL,
  `br` bigint(20) unsigned NOT NULL,
  `bw` bigint(20) unsigned NOT NULL,
  `oc` bigint(20) unsigned NOT NULL,
  `cc` bigint(20) unsigned NOT NULL,
  `rdc` bigint(20) unsigned NOT NULL,
  `wc` bigint(20) unsigned NOT NULL,
  `dir` bigint(20) unsigned NOT NULL,
  `iu` bigint(20) unsigned NOT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `sfavdcounters` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `arraynum` int(10) unsigned NOT NULL,
  `controllernum` int(10) unsigned NOT NULL,
  `timestamp` int(10) unsigned NOT NULL,
  `time` int(10) unsigned NOT NULL,
  `vdnum` int(10) unsigned NOT NULL,
  `kb` bigint(20) unsigned NOT NULL,
  `iops` bigint(20) unsigned NOT NULL,
  `kbio` bigint(20) unsigned NOT NULL,
  `riops` bigint(20) unsigned NOT NULL,
  `wiops` bigint(20) unsigned NOT NULL,
  `fwios` bigint(20) unsigned NOT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


