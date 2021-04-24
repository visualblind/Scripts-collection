<?php
/*
 *  Module written/ported by Eric Kilfoil <eric@ypass.net>
 * 
 *  This is the copyright notice from the PERL Net::DNS module:
 *
 *  Copyright (c) 1997-2000 Michael Fuhr.  All rights reserved.  This
 *  program is free software; you can redistribute it and/or modify it
 *  under the same terms as Perl itself.
 *
 *  The majority of this is _NOT_ my code.  I simply ported it from the
 *  PERL Net::DNS module.  
 *
 *  The author of the Net::DNS module is Michael Fuhr <mike@fuhr.org>
 *  http://www.fuhr.org/~mfuhr/perldns/
 *
 *  I _DO_ maintain this code, and Miachael Fuhr has nothing to with the
 *  porting of this code to PHP.  Any questions directly related to this
 *  class library should be directed to me.
 *
 *  I'll be setting up a CVS repository for this class soon.  The more
 *  emails i get concerning this, the more apt i am to do it.
 *
 *  License Information:
 *
 *    Net_DNS:  A resolver library for PHP
 *    Copyright (c) 2002-2003 Eric Kilfoil eric@ypass.net
 *
 *    This library is free software; you can redistribute it and/or
 *    modify it under the terms of the GNU Lesser General Public
 *    License as published by the Free Software Foundation; either
 *    version 2.1 of the License, or (at your option) any later version.
 *
 *    This library is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *    Lesser General Public License for more details.
 *
 *    You should have received a copy of the GNU Lesser General Public
 *    License along with this library; if not, write to the Free Software
 *    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

/* Include information {{{ */

    require_once('Net/DNS/Header.php');
    require_once('Net/DNS/Question.php');
    require_once('Net/DNS/Packet.php');
    require_once('Net/DNS/Resolver.php');
    require_once('Net/DNS/RR.php');

/* }}} */
/* GLOBAL VARIABLE definitions {{{ */

// Used by the Net_DNS_Resolver object to generate an ID
mt_srand(floor(microtime(true) * 10000));
$GLOBALS['_Net_DNS_packet_id'] = mt_rand(0, 65535);

/* }}} */
/* Net_DNS object definition (incomplete) {{{ */
/**
 * Initializes a resolver object
 *
 * Net_DNS allows you to query a nameserver for DNS lookups.  It bypasses the
 * system resolver library  entirely, which allows you to query any nameserver,
 * set your own values for retries, timeouts, recursion, etc.
 *
 * @author Eric Kilfoil <eric@ypass.net>
 * @package Net_DNS
 * @version 0.01alpha
 */
class Net_DNS
{
    /* class variable definitions {{{ */
    /**
     * A default resolver object created on instantiation
     *
     * @var object Net_DNS_Resolver
     */
    var $resolver;
    var $VERSION = '1.00b2'; // This should probably be a define :(
    var $PACKETSZ = 512;
    var $HFIXEDSZ = 12;
    var $QFIXEDSZ = 4;
    var $RRFIXEDSZ = 10;
    var $INT32SZ = 4;
    var $INT16SZ = 2;
    
    /* }}} */
    /* class constructor - Net_DNS() {{{ */
    /**
     * Initializes a resolver object
     *
     * @see Net_DNS_Resolver
     */
    function Net_DNS()
    {
        $this->resolver = new Net_DNS_Resolver();
    }
    /* }}} */
    /* Net_DNS::opcodesbyname() {{{ */
    /**
     * Translates opcode names to integers
     *
     * Translates the name of a DNS OPCODE into it's assigned  number
     * listed in RFC1035, RFC1996, or RFC2136. Valid  OPCODES are:
     * <ul>
     *   <li>QUERY   
     *   <li>IQUERY   
     *   <li>STATUS   
     *   <li>NS_NOTIFY_OP   
     *   <li>UPDATE
     * <ul>
     * 
     * @param   string  $opcode A DNS Packet OPCODE name
     * @return  integer The integer value of an OPCODE
     * @see     Net_DNS::opcodesbyval()
     */
    function opcodesbyname($opcode)
    {
        $op = array(
                'QUERY'        => 0,   // RFC 1035
                'IQUERY'       => 1,   // RFC 1035
                'STATUS'       => 2,   // RFC 1035
                'NS_NOTIFY_OP' => 4,   // RFC 1996
                'UPDATE'       => 5,   // RFC 2136
                );
        return (array_key_exists($opcode, $op) ? $op[$opcode] : NULL);
    }

    /* }}} */
    /* Net_DNS::opcodesbyval() {{{*/
    /**
     * Translates opcode integers into names
     *
     * Translates the integer value of an opcode into it's name
     * 
     * @param   integer $opcodeval  A DNS packet opcode integer
     * @return  string  The name of the OPCODE
     * @see     Net_DNS::opcodesbyname()
     */
    function opcodesbyval($opcodeval)
    {
        $opval = array(
                0 => 'QUERY',
                1 => 'IQUERY',
                2 => 'STATUS',
                4 => 'NS_NOTIFY_OP',
                5 => 'UPDATE',
                );
        return (array_key_exists($opcodeval, $opval) ? $opval[$opcodeval] : NULL);
    }

    /*}}}*/
    /* Net_DNS::rcodesbyname() {{{*/
    /**
     * Translates rcode names to integers
     *
     * Translates the name of a DNS RCODE (result code) into it's assigned number.
     * <ul>
     *   <li>NOERROR   
     *   <li>FORMERR   
     *   <li>SERVFAIL   
     *   <li>NXDOMAIN   
     *   <li>NOTIMP   
     *   <li>REFUSED   
     *   <li>YXDOMAIN   
     *   <li>YXRRSET   
     *   <li>NXRRSET   
     *   <li>NOTAUTH   
     *   <li>NOTZONE
     * <ul>
     * 
     * @param   string  $rcode  A DNS Packet RCODE name
     * @return  integer The integer value of an RCODE
     * @see     Net_DNS::rcodesbyval()
     */
    function rcodesbyname($rcode)
    {
        $rc = array(
                'NOERROR'   => 0,   // RFC 1035
                'FORMERR'   => 1,   // RFC 1035
                'SERVFAIL'  => 2,   // RFC 1035
                'NXDOMAIN'  => 3,   // RFC 1035
                'NOTIMP'    => 4,   // RFC 1035
                'REFUSED'   => 5,   // RFC 1035
                'YXDOMAIN'  => 6,   // RFC 2136
                'YXRRSET'   => 7,   // RFC 2136
                'NXRRSET'   => 8,   // RFC 2136
                'NOTAUTH'   => 9,   // RFC 2136
                'NOTZONE'   => 10,    // RFC 2136
                );
        return (array_key_exists($rcode, $rc) ? $rc[$rcode] : NULL);
    }

    /*}}}*/
    /* Net_DNS::rcodesbyval() {{{*/
    /**
     * Translates rcode integers into names
     *
     * Translates the integer value of an rcode into it's name
     * 
     * @param   integer $rcodeval   A DNS packet rcode integer
     * @return  string  The name of the RCODE
     * @see     Net_DNS::rcodesbyname()
     */
    function rcodesbyval($rcodeval)
    {
        $rc = array(
                0 => 'NOERROR',
                1 => 'FORMERR',
                2 => 'SERVFAIL',
                3 => 'NXDOMAIN',
                4 => 'NOTIMP',
                5 => 'REFUSED',
                6 => 'YXDOMAIN',
                7 => 'YXRRSET',
                8 => 'NXRRSET',
                9 => 'NOTAUTH',
                10 => 'NOTZONE',
                );
        return (array_key_exists($rcodeval, $rc) ? $rc[$rcodeval] : NULL);
    }

    /*}}}*/
    /* Net_DNS::typesbyname() {{{*/
    /**
     * Translates RR type names into integers
     *
     * Translates a Resource Record from it's name to it's  integer value.
     * Valid resource record types are:
     *
     * <ul>
     *   <li>A   
     *   <li>NS   
     *   <li>MD   
     *   <li>MF   
     *   <li>CNAME   
     *   <li>SOA   
     *   <li>MB   
     *   <li>MG   
     *   <li>MR   
     *   <li>NULL   
     *   <li>WKS   
     *   <li>PTR   
     *   <li>HINFO   
     *   <li>MINFO   
     *   <li>MX   
     *   <li>TXT   
     *   <li>RP   
     *   <li>AFSDB   
     *   <li>X25   
     *   <li>ISDN   
     *   <li>RT   
     *   <li>NSAP   
     *   <li>NSAP_PTR   
     *   <li>SIG   
     *   <li>KEY   
     *   <li>PX   
     *   <li>GPOS   
     *   <li>AAAA   
     *   <li>LOC   
     *   <li>NXT   
     *   <li>EID   
     *   <li>NIMLOC   
     *   <li>SRV   
     *   <li>ATMA   
     *   <li>NAPTR   
     *   <li>TSIG   
     *   <li>UINFO   
     *   <li>UID   
     *   <li>GID   
     *   <li>UNSPEC   
     *   <li>IXFR   
     *   <li>AXFR   
     *   <li>MAILB   
     *   <li>MAILA   
     *   <li>ANY
     * <ul>
     * 
     * @param   string  $rrtype A DNS packet RR type name   
     * @return  integer The integer value of an RR type
     * @see     Net_DNS::typesbyval()
     */
    function typesbyname($rrtype)
    {
        $rc = array(
            'SIGZERO'   => 0,       // RFC2931 consider this a pseudo type
            'A'         => 1,       // RFC 1035, Section 3.4.1
            'NS'        => 2,       // RFC 1035, Section 3.3.11
            'MD'        => 3,       // RFC 1035, Section 3.3.4 (obsolete)
            'MF'        => 4,       // RFC 1035, Section 3.3.5 (obsolete)
            'CNAME'     => 5,       // RFC 1035, Section 3.3.1
            'SOA'       => 6,       // RFC 1035, Section 3.3.13
            'MB'        => 7,       // RFC 1035, Section 3.3.3
            'MG'        => 8,       // RFC 1035, Section 3.3.6
            'MR'        => 9,       // RFC 1035, Section 3.3.8
            'NULL'      => 10,      // RFC 1035, Section 3.3.10
            'WKS'       => 11,      // RFC 1035, Section 3.4.2 (deprecated)
            'PTR'       => 12,      // RFC 1035, Section 3.3.12
            'HINFO'     => 13,      // RFC 1035, Section 3.3.2
            'MINFO'     => 14,      // RFC 1035, Section 3.3.7
            'MX'        => 15,      // RFC 1035, Section 3.3.9
            'TXT'       => 16,      // RFC 1035, Section 3.3.14
            'RP'        => 17,      // RFC 1183, Section 2.2
            'AFSDB'     => 18,      // RFC 1183, Section 1
            'X25'       => 19,      // RFC 1183, Section 3.1
            'ISDN'      => 20,      // RFC 1183, Section 3.2
            'RT'        => 21,      // RFC 1183, Section 3.3
            'NSAP'      => 22,      // RFC 1706, Section 5
            'NSAP_PTR'  => 23,      // RFC 1348 (obsolete)
            // The following 2 RRs are impemented in Net::DNS::SEC
            'SIG'       => 24,      // RFC 2535, Section 4.1
            'KEY'       => 25,      // RFC 2535, Section 3.1
            'PX'        => 26,      // RFC 2163,
            'GPOS'      => 27,      // RFC 1712 (obsolete)
            'AAAA'      => 28,      // RFC 1886, Section 2.1
            'LOC'       => 29,      // RFC 1876
            // The following RR is impemented in Net::DNS::SEC
            'NXT'       => 30,      // RFC 2535, Section 5.2
            'EID'       => 31,      // draft-ietf-nimrod-dns-xx.txt
            'NIMLOC'    => 32,      // draft-ietf-nimrod-dns-xx.txt
            'SRV'       => 33,      // RFC 2052
            'ATMA'      => 34,      // ???
            'NAPTR'     => 35,      // RFC 2168
            'KX'        => 36,      // RFC 2230
            'CERT'      => 37,      // RFC 2538
            'DNAME'     => 39,      // RFC 2672
            'OPT'       => 41,      // RFC 2671
            // The following 4 RRs are impemented in Net::DNS::SEC
            // Aug 2003: These RRs will be published as RFCs shortly 
            'DS'        => 43,      // draft-ietf-dnsext-delegation-signer
            'SSHFP'     => 44,          // draft-ietf-secsh-dns (No RFC // yet at time of coding)
            'RRSIG'     => 46,      // draft-ietf-dnsext-dnssec-2535typecode-change
            'NSEC'      => 47,      // draft-ietf-dnsext-dnssec-2535typecode-change
            'DNSKEY'    => 48,      // draft-ietf-dnsext-dnssec-2535typecode-change
            'UINFO'     => 100,     // non-standard
            'UID'       => 101,     // non-standard
            'GID'       => 102,     // non-standard
            'UNSPEC'    => 103,     // non-standard
            'TKEY'      => 249,     // RFC 2930
            'TSIG'      => 250,     // RFC 2931
            'IXFR'      => 251,     // RFC 1995
            'AXFR'      => 252,     // RFC 1035
            'MAILB'     => 253,     // RFC 1035 (MB, MG, MR)
            'MAILA'     => 254,     // RFC 1035 (obsolete - see MX)
            'ANY'       => 255      // RFC 1035
            );
        if (array_key_exists($rrtype, $rc)) {
            return $rc[$rrtype];
        } else {
            $matches= null;
            preg_match('/^\s*TYPE(\d+)\s*$/', $rrtype, $matches);
            if (is_array($matches) && (count($matches) == 2) && ($matches[1] < 256)) {
                return $matches[1];
            } else {
                return NULL;
            }
        }
    }

    /*}}}*/
    /* Net_DNS::typesbyval() {{{*/
    /**
     * Translates RR type integers into names
     *
     * Translates the integer value of an RR type into it's name
     * 
     * @param   integer $rrtypeval  A DNS packet RR type integer
     * @return  string  The name of the RR type
     * @see     Net_DNS::typesbyname()
     */
    function typesbyval($rrtypeval)
    {
        $rc = array(
            0           => 'SIGZERO',  // RFC2931 consider this a pseudo type
            1           => 'A',        // RFC 1035, Section 3.4.1
            2           => 'NS',       // RFC 1035, Section 3.3.11
            3           => 'MD',       // RFC 1035, Section 3.3.4 (obsolete)
            4           => 'MF',       // RFC 1035, Section 3.3.5 (obsolete)
            5           => 'CNAME',    // RFC 1035, Section 3.3.1
            6           => 'SOA',      // RFC 1035, Section 3.3.13
            7           => 'MB',       // RFC 1035, Section 3.3.3
            8           => 'MG',       // RFC 1035, Section 3.3.6
            9           => 'MR',       // RFC 1035, Section 3.3.8
            10          => 'NULL',     // RFC 1035, Section 3.3.10
            11          => 'WKS',      // RFC 1035, Section 3.4.2 (deprecated)
            12          => 'PTR',      // RFC 1035, Section 3.3.12
            13          => 'HINFO',    // RFC 1035, Section 3.3.2
            14          => 'MINFO',    // RFC 1035, Section 3.3.7
            15          => 'MX',       // RFC 1035, Section 3.3.9
            16          => 'TXT',      // RFC 1035, Section 3.3.14
            17          => 'RP',       // RFC 1183, Section 2.2
            18          => 'AFSDB',    // RFC 1183, Section 1
            19          => 'X25',      // RFC 1183, Section 3.1
            20          => 'ISDN',     // RFC 1183, Section 3.2
            21          => 'RT',       // RFC 1183, Section 3.3
            22          => 'NSAP',     // RFC 1706, Section 5
            23          => 'NSAP_PTR', // RFC 1348 (obsolete)
            // The following 2 RRs are impemented in Net::DNS::SEC
            24          => 'SIG',      // RFC 2535, Section 4.1
            25          => 'KEY',      // RFC 2535, Section 3.1
            26          => 'PX',       // RFC 2163,
            27          => 'GPOS',     // RFC 1712 (obsolete)
            28          => 'AAAA',     // RFC 1886, Section 2.1
            29          => 'LOC',      // RFC 1876
            // The following RR is impemented in Net::DNS::SEC
            30          => 'NXT',      // RFC 2535, Section 5.2
            31          => 'EID',      // draft-ietf-nimrod-dns-xx.txt
            32          => 'NIMLOC',   // draft-ietf-nimrod-dns-xx.txt
            33          => 'SRV',      // RFC 2052
            34          => 'ATMA',     // ???
            35          => 'NAPTR',    // RFC 2168
            36          => 'KX',       // RFC 2230
            37          => 'CERT',     // RFC 2538
            39          => 'DNAME',    // RFC 2672
            41          => 'OPT',      // RFC 2671
            // The following 4 RRs are impemented in Net::DNS::SEC
            // Aug 2003: These RRs will be published as RFCs shortly 
            43          => 'DS',       // draft-ietf-dnsext-delegation-signer
            44          => 'SSHFP',      // draft-ietf-secsh-dns (No RFC // yet at time of coding)
            46          => 'RRSIG',    // draft-ietf-dnsext-dnssec-2535typecode-change
            47          => 'NSEC',     // draft-ietf-dnsext-dnssec-2535typecode-change
            48          => 'DNSKEY',   // draft-ietf-dnsext-dnssec-2535typecode-change
            100         => 'UINFO',    // non-standard
            101         => 'UID',      // non-standard
            102         => 'GID',      // non-standard
            103         => 'UNSPEC',   // non-standard
            249         => 'TKEY',     // RFC 2930
            250         => 'TSIG',     // RFC 2931
            251         => 'IXFR',     // RFC 1995
            252         => 'AXFR',     // RFC 1035
            253         => 'MAILB',    // RFC 1035 (MB, MG, MR)
            254         => 'MAILA',    // RFC 1035 (obsolete - see MX)
            255         => 'ANY'       // RFC 1035
            );
        $matches= null;
        preg_match('/^\s*\d+\s*$/', $rrtypeval, $matches);
        if (is_array($matches) && (count($matches) == 1)) {
            $rrtypeval= preg_replace('/\s*/', '', $matches[0]);
            $rrtypeval= preg_replace('/^0*/', '', $rrtypeval);
            if (array_key_exists($rrtypeval, $rc)) {
                return $rc[$rrtypeval];
            } elseif ($rrtypeval < 256) {
                return $rrtypeval;
            } else {
                return NULL;
            }
        } else {
            return NULL;
        }
    }

    /*}}}*/
    /* Net_DNS::classesbyname() {{{*/
    /**
     * translates a DNS class from it's name to it's  integer value. Valid
     * class names are:
     * <ul>
     *   <li>IN   
     *   <li>CH   
     *   <li>HS   
     *   <li>NONE   
     *   <li>ANY
     * </ul>
     * 
     * @param   string  $class  A DNS packet class type
     * @return  integer The integer value of an class type
     * @see     Net_DNS::classesbyval()
     */
    function classesbyname($class)
    {
        $rc = array(
                'IN'    => 1,   // RFC 1035
                'CH'    => 3,   // RFC 1035
                'HS'    => 4,   // RFC 1035
                'NONE'  => 254, // RFC 2136
                'ANY'   => 255  // RFC 1035
                );
        return (array_key_exists($class, $rc) ? $rc[$class] : NULL);
    }

    /*}}}*/
    /* Net_DNS::classesbyval() {{{*/
    /**
     * Translates RR class integers into names
     *
     * Translates the integer value of an RR class into it's name
     * 
     * @param   integer $classval   A DNS packet RR class integer
     * @return  string  The name of the RR class
     * @see     Net_DNS::classesbyname()
     */
    function classesbyval($classval)
    {
        $rc = array(
                1 => 'IN',
                3 => 'CH',
                4 => 'HS',
                254 => 'NONE',
                255 => 'ANY'
                );
        return (array_key_exists($classval, $rc) ? $rc[$classval] : NULL);
    }

    /*}}}*/
    /* not completed - Net_DNS::mx() {{{*/
    /*}}}*/
    /* not completed - Net_DNS::yxrrset() {{{*/
    /*}}}*/
    /* not completed - Net_DNS::nxrrset() {{{*/
    /*}}}*/
    /* not completed - Net_DNS::yxdomain() {{{*/
    /*}}}*/
    /* not completed - Net_DNS::nxdomain() {{{*/
    /*}}}*/
    /* not completed - Net_DNS::rr_add() {{{*/
    /*}}}*/
    /* not completed - Net_DNS::rr_del() {{{*/
    /*}}}*/
}
/* }}} */
/* VIM Settings {{{
 * Local variables:
 * tab-width: 4
 * c-basic-offset: 4
 * soft-stop-width: 4
 * c indent on
 * End:
 * vim600: sw=4 ts=4 sts=4 cindent fdm=marker et
 * vim<600: sw=4 ts=4
 * }}} */
?>
