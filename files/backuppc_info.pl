#!/usr/bin/perl

# Backuppc
use lib "/usr/share/backuppc/lib";
use BackupPC::Lib;
use BackupPC::CGI::Lib;

#Other
use Data::Dumper;

# Globals
$bpc = BackupPC::Lib->new();
$hosts = $bpc->HostInfoRead();

# Setup
&var_config();
&zabbix_config();

# %Info = Pool Info
# %QueueLen = Command Queues
# %Jobs = jobs

# Collect Data
GetStatusInfo("jobs queueLen info");
#print Dumper(%Info);
&jobs_info();
&pool_info();
&queue_info();
&general_info();
&hosts_info();

# Push Data to Zabbix
foreach my $key (keys %Val) {
        if ($Var{$key})
        {
                zabbix_post($Var{$key},$Val{$key});
                print "$Var{$key} | $Val{$key}\n";
        }
}
print "1";


# Functions
sub hosts_info
{
        # Variables
        $fullSizeTot = 0;
        $fullCnt = 0;
        $fullCnt2 = 0;
        $incrSizeTot = 0;
        $incrCnt = 0;
        $incrCnt2 = 0;
        $total_speed_full = 0;
        $total_speed_incr = 0;

        $no_backups_2 = "NONE";
        $no_backups_3 = "NONE";
        $no_backups_4 = "NONE";
        $no_backups_5 = "NONE";

        while ( my ($host, $value) = each(%$hosts) )
        {

                my @Backups = $bpc->BackupInfoRead($host);
                $bpc->ConfigRead($host);
                my %Conf = $bpc->Conf();

                # Variables
                my $fullAge;
                my $fullSize;
                my $fullDur;
                my $incrAge;
                my $incrSize;
                my $incrDur;

                for ( my $i = 0 ; $i < @Backups ; $i++ ) 
                {
                        if ( $Backups[$i]{type} eq "full" ) 
                        {
                                $fullCnt++;
                                if ( $fullAge < 0 || $Backups[$i]{startTime} > $fullAge ) 
                                {
                                        $fullAge  = $Backups[$i]{startTime};
                                        $fullSize = $Backups[$i]{size};
                                        $fullDur  = $Backups[$i]{endTime} - $Backups[$i]{startTime};
                                }
                        $fullSizeTot += $Backups[$i]{size};
                        } 
                        else 
                        {
                                $incrCnt++;
                                if ( $incrAge < 0 || $Backups[$i]{startTime} > $incrAge ) 
                                {
                                        $incrAge  = $Backups[$i]{startTime};
                                        $incrSize = $Backups[$i]{size};
                                        $incrDur  = $Backups[$i]{endTime} - $Backups[$i]{startTime};
                                }
                                $incrSizeTot += $Backups[$i]{size};
                        }
                }
                # Sum the Last Full Backup Speed
                if ($fullSize > 0 && $fullDur >0)
                {
                        $total_speed_full += ($fullSize / $fullDur);
                        $fullCnt2++;
                }
                # Sum the Last Full Incr Speed
                if ($incrSize > 0 && $incrDur >0)
                {
                        $total_speed_incr += ($incrSize / $incrDur);
                        $incrCnt2++;
                }

                if ($host eq "haulingaz")
                { 
                        print "Full Age: $fullAge\n";
                        print "Full Period: $Conf{FullPeriod}\n";
                        print "Incr Age: $incrAge\n";
                        print "Incr Period: $Conf{IncrPeriod}\n";
                }

                # Check for Hosts that don't have backups (Full)         
                my $skip_inc = 0;

                # If we have a full that less than 2 days old we can skip
                if ( (time() - $fullAge) < ( (86400 * 2) ) && $Conf{BackupsDisable} == 0 )
                { $skip_inc = 1;}

                # If we don't have any fulls, we are going to set the no_backups so we can skip inc
                if ( (time() - $fullAge) > ( ($Conf{FullPeriod} * 86400) + (86400 * 2) ) && $Conf{BackupsDisable} == 0 )
                { if ($no_backups_2 eq "NONE") { $no_backups_2 = "$host"} else { $no_backups_2 .= "\n$host" } $skip_inc = 1;}

                if ( (time() - $fullAge) > ( ($Conf{FullPeriod} * 86400) + (86400 * 3) ) && $Conf{BackupsDisable} == 0 )
                { if ($no_backups_3 eq "NONE") { $no_backups_3 = "$host"} else { $no_backups_3 .= "\n$host" } $skip_inc = 1;}

                if ( (time() - $fullAge) > ( ($Conf{FullPeriod} * 86400) + (86400 * 4) ) && $Conf{BackupsDisable} == 0 )
                { if ($no_backups_4 eq "NONE") { $no_backups_4 = "$host"} else { $no_backups_4 .= "\n$host" } $skip_inc = 1;}

                if ( (time() - $fullAge) > ( ($Conf{FullPeriod} * 86400) + (86400 * 5) ) && $Conf{BackupsDisable} == 0 )
                { if ($no_backups_5 eq "NONE") { $no_backups_5 = "$host"} else { $no_backups_5 .= "\n$host" } $skip_inc = 1;}

                # Check for Hosts that don't have backups (Incremental)
                if ( (time() - $incrAge) > ( ($Conf{IncrPeriod} * 86400) + (86400 * 2) ) && $Conf{BackupsDisable} == 0 && $Conf{IncrKeepCnt} > 0 && $skip_inc == 0)
                { if ($no_backups_2 eq "NONE") { $no_backups_2 = "$host"} else { $no_backups_2 .= "\n$host" } }

                if ( (time() - $incrAge) > ( ($Conf{IncrPeriod} * 86400) + (86400 * 3) ) && $Conf{BackupsDisable} == 0 && $Conf{IncrKeepCnt} > 0 && $skip_inc == 0)
                { if ($no_backups_3 eq "NONE") { $no_backups_3 = "$host"} else { $no_backups_3 .= "\n$host" } }

                if ( (time() - $incrAge) > ( ($Conf{IncrPeriod} * 86400) + (86400 * 4) ) && $Conf{BackupsDisable} == 0 && $Conf{IncrKeepCnt} > 0 && $skip_inc == 0)
                { if ($no_backups_4 eq "NONE") { $no_backups_4 = "$host"} else { $no_backups_4 .= "\n$host" } }

                if ( (time() - $incrAge) > ( ($Conf{IncrPeriod} * 86400) + (86400 * 5) ) && $Conf{BackupsDisable} == 0 && $Conf{IncrKeepCnt} > 0 && $skip_inc == 0)
                { if ($no_backups_5 eq "NONE") { $no_backups_5 = "$host"} else { $no_backups_5 .= "\n$host" } }


        }
        if ($fullCnt2 > 0 )
        { $Val{hostsAvgFullSpeed} = ($total_speed_full / $fullCnt2); }
        if ($incrCnt2 > 0 )
        { $Val{hostsAvgIncrSpeed} = ($total_speed_incr / $incrCnt2); }
        $Val{hostsFullSize}  = $fullSizeTot;
        $Val{hostsFullCount} = $fullCnt;
        $Val{hostsIncrSize}  = $incrSizeTot;
        $Val{hostsIncrCount} = $incrCnt;
        $Val{hostsNoBackups2} = $no_backups_2;
        $Val{hostsNoBackups3} = $no_backups_3;
        $Val{hostsNoBackups4} = $no_backups_4;
        $Val{hostsNoBackups5} = $no_backups_5;
}

sub pool_info
{
        while ( my ($key, $value) = each(%Info) )
        {
                if ($key =~ /pool/)
                {$Val{$key} = int($Info{$key}); }
        }
}


sub general_info
{
        $Val{startTime}                         = time() - $Info{startTime};
        $Val{Version}                           = $Info{Version};
        $Val{ConfigLTime}                       = time() - $Info{ConfigLTime};

}

sub queue_info
{
        while ( my ($key, $value) = each(%QueueLen) ) 
        {
                if ($key =~ /Queue/)
                {$Val{$key} = $QueueLen{$key};}
        }
}

sub jobs_info 
{
        $Val{JobsIncr}  = 0;
        $Val{JobsFull}  = 0;
        $Val{JobsOther} = 0;

        # Jobs
        while ( my ($key, $value) = each(%Jobs) ) {
                #print "$key => $value\n";
                #print Dumper($value);
                if (!($key =~ /trashClean/i))
                {
                        # Count Incrementail Jobs
                        if( $value->{'type'} eq 'incr')
                        { $Val{JobsIncr}++; }

                        # Count Full Jobs
                        elsif( $value->{'type'} eq 'full')
                        { $Val{JobsFull}++; }

                        # Everything Else
                        else { $Val{JobsOther}++; }
                }
        }

}

sub GetStatusInfo
{
    my($status) = @_;
    ServerConnect();
    %Status = ()     if ( $status =~ /\bhosts\b/ );
    %StatusHost = () if ( $status =~ /\bhost\(/ );
    my $reply = $bpc->ServerMesg("status $status");
    $reply = $1 if ( $reply =~ /(.*)/s );
    eval($reply);
    # ignore status related to admin and trashClean jobs
    if ( $status =~ /\bhosts\b/ ) {
        foreach my $host ( grep(/admin/, keys(%Status)) ) {
            delete($Status{$host}) if ( $bpc->isAdminJob($host) );
        }
        delete($Status{$bpc->trashJob});
    }
}

#
# Returns the list of hosts that should appear in the navigation bar
# for this user.  If $getAll is set, the admin gets all the hosts.
# Otherwise, regular users get hosts for which they are the user or
# are listed in the moreUsers column in the hosts file.
#
sub GetUserHosts
{
    my($getAll) = @_;
    my @hosts;

    if ( $getAll ) {
        @hosts = sort keys %$Hosts;
    } else {
        @hosts = sort grep { $Hosts->{$_}{user} eq $User ||
                       defined($Hosts->{$_}{moreUsers}{$User}) } keys(%$Hosts);
    }
    return @hosts;
}


sub ServerConnect
{
    #
    # Verify that the server connection is ok
    #
    return if ( $bpc->ServerOK() );
    $bpc->ServerDisconnect();
    if ( my $err = $bpc->ServerConnect($Conf{ServerHost}, $Conf{ServerPort}) ) {
        if ( CheckPermission()
          && -f $Conf{ServerInitdPath}
          && $Conf{ServerInitdStartCmd} ne "" ) {
            my $content = eval("qq{$Lang->{Admin_Start_Server}}");
            Header(eval("qq{$Lang->{Unable_to_connect_to_BackupPC_server}}"), $content);
            Trailer();
            exit(1);
        } else {
            ErrorExit(eval("qq{$Lang->{Unable_to_connect_to_BackupPC_server}}"));
        }
    }
}


sub zabbix_config {

        open(CONFIG,"/etc/zabbix/zabbix_agentd.conf");
        foreach(<CONFIG>)
        {
                $zabbix_host = $1 if (/Hostname\s*=\s*(.*)/); 
                $zabbix_server = $1 if (/Server\s*=\s*(.*)/);
        }
        close CONFIG;
}

sub zabbix_post {
        my $key = $_[0];
        my $val = $_[1];

        my $cmd = "zabbix_sender -z $zabbix_server -p 10051 -s $zabbix_host -k $key -o '$val'";
        system("$cmd >/dev/null");
}


sub var_config { 

        # Pool Info
        $Var{poolFileCnt}                       = "backuppc.pool_file_count";
        $Var{poolDirCnt}                        = "backuppc.pool_dir_count";
        #$Var{poolFileCntRm}                    = "backuppc.pool_file_removed";
        $Var{poolFileCntRep}                    = "backuppc.pool_file_repeat";
        $Var{poolFileRepMax}                    = "backuppc.pool_file_repeat_max";
        $Var{poolFileLinkMax}                   = "backuppc.pool_file_link_max";
        $Var{poolKb}                            = "backuppc.pool_size";
        $Var{cpoolFileCnt}                      = "backuppc.cpool_file_count";
        $Var{cpoolDirCnt}                       = "backuppc.cpool_dir_count";
        #$Var{cpoolFileCntRm}                   = "backuppc.cpool_file_removed";
        $Var{cpoolFileCntRep}                   = "backuppc.cpool_file_repeat";
        $Var{cpoolFileRepMax}                   = "backuppc.cpool_file_repeat_max";
        $Var{cpoolFileLinkMax}                  = "backuppc.cpool_file_link_max";
        $Var{cpoolKb}                           = "backuppc.cpool_size";

        # General Stats
        $Var{startTime}                         = "backuppc.uptime";
        $Var{Version}                           = "backuppc.version";
        $Var{ConfigLTime}                       = "backuppc.config_load_time";

        # Queues
        $Var{CmdQueue}                          = "backuppc.queue_command";
        $Var{UserQueue}                         = "backuppc.queue_user";
        $Var{BgQueue}                           = "backuppc.queue_background";

        # Jobs
        $Var{JobsIncr}                          = "backuppc.jobs_incr";
        $Var{JobsFull}                          = "backuppc.jobs_full";
        $Var{JobsOther}                         = "backuppc.jobs_other";

        # Hosts
        $Var{hostsAvgFullSpeed}                 = "backuppc.hosts_full_speed";
        $Var{hostsAvgIncrSpeed}                 = "backuppc.hosts_incr_speed";
        $Var{hostsFullSize}                     = "backuppc.hosts_full_size";
        $Var{hostsFullCount}                    = "backuppc.hosts_full_count";
        $Var{hostsIncrSize}                     = "backuppc.hosts_incr_size";
        $Var{hostsIncrCount}                    = "backuppc.hosts_incr_count";
        $Var{hostsNoBackups2}                   = "backuppc.hosts_nobackup_2";
        $Var{hostsNoBackups3}                   = "backuppc.hosts_nobackup_3";
        $Var{hostsNoBackups4}                   = "backuppc.hosts_nobackup_4";
        $Var{hostsNoBackups5}                   = "backuppc.hosts_nobackup_5";
}

