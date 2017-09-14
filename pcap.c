#include <stdlib.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <pcap/pcap.h>
#include <sys/time.h>

/* from http://www.tcpdump.org/pcap.html
 */
#define ETHER_ADDR_LEN	6

/* Ethernet header */
struct ether_hdr {
  u_char ether_dhost[ETHER_ADDR_LEN]; /* Destination host address */
  u_char ether_shost[ETHER_ADDR_LEN]; /* Source host address */
  u_short ether_type; /* IP? ARP? RARP? etc */
};

/* IP header */
struct ip_hdr {
  u_char ip_vhl;		/* version << 4 | header length >> 2 */
  u_char ip_tos;		/* type of service */
  u_short ip_len;		/* total length */
  u_short ip_id;		/* identification */
  u_short ip_off;		/* fragment offset field */
#define IP_RF 0x8000		/* reserved fragment flag */
#define IP_DF 0x4000		/* dont fragment flag */
#define IP_MF 0x2000		/* more fragments flag */
#define IP_OFFMASK 0x1fff	/* mask for fragmenting bits */
  u_char ip_ttl;		/* time to live */
  u_char ip_p;		/* protocol */
  u_short ip_sum;		/* checksum */
  struct in_addr ip_src,ip_dst; /* source and dest address */
};
#define IP_HL(ip)		(((ip)->ip_vhl) & 0x0f)
#define IP_V(ip)		(((ip)->ip_vhl) >> 4)

/* TCP header */
typedef u_int tcp_seq;

struct tcp_hdr {
  u_short th_sport;	/* source port */
  u_short th_dport;	/* destination port */
  tcp_seq th_seq;		/* sequence number */
  tcp_seq th_ack;		/* acknowledgement number */
  u_char th_offx2;	/* data offset, rsvd */
#define TH_OFF(th)	(((th)->th_offx2 & 0xf0) >> 4)
  u_char th_flags;
#define TH_FIN 0x01
#define TH_SYN 0x02
#define TH_RST 0x04
#define TH_PUSH 0x08
#define TH_ACK 0x10
#define TH_URG 0x20
#define TH_ECE 0x40
#define TH_CWR 0x80
#define TH_FLAGS (TH_FIN|TH_SYN|TH_RST|TH_ACK|TH_URG|TH_ECE|TH_CWR)
  u_short th_win;		/* window */
  u_short th_sum;		/* checksum */
  u_short th_urp;		/* urgent pointer */
};

void pr_ether(const u_char *ptr) {
  int i;

  for(i = 0; i < 6; i++) {
    printf("%02x", ptr[i]);
    if(i != 5) {
      printf(":");
    }
  }
}

void pr_hex(const u_char *ptr, int len) {
  int i, j;

  for(i = 0; i < len; i++) {
    printf("%02x ", ptr[i]);
    j = i + 1;
    
    if(j < 15) {
      if(j % 14 == 0) {
	printf("\n");
	continue;
      }

      if(j % 6 == 0) {
	printf("   ");
      }

      continue;
    }
    j -= 14;

    if(j % 10 == 0) {
      printf("\n");
      continue;
    }

    if(j % 5 == 0) {
      printf("   ");
      continue;
    }
  }

  printf("\n\n\n\n");
}


int main(int argc, char **argv) {
  pcap_t *pcap;
  char errbuf[256];
  int pkt_count = 0;

  pcap = pcap_open_offline("./data/foo-2.pcap", errbuf);
  if(pcap == NULL) {
    printf("Couldn't open ./data/foo.pcap: %s", errbuf);
    exit(1);
  }

  printf("[\n");

  while(1) {
    const u_char *pkt;
    struct ether_hdr *eph;
    struct ip_hdr *iph;
    struct tcp_hdr *tcph;
    struct unified_hdr *uph;
    char ip_src[INET_ADDRSTRLEN];
    char ip_dst[INET_ADDRSTRLEN];
    struct pcap_pkthdr packet_header;
    int ip_offset = 14;

    pkt = pcap_next(pcap, &packet_header);
    if(pkt == NULL) {
      /*      printf("out of packets, processed %d\n", pkt_count); */
      break;
    }

    if(pkt_count > 0) {
      printf(",\n\n");
    }

    pkt_count++;

    /*
    printf("got %d bytes\n", packet_header.len);
    printf("caplen %d bytes\n", packet_header.caplen);
    pr_hex(pkt, packet_header.len);

    pr_ether(pkt);
    printf(" -> ");
    pr_ether(pkt + 6);
    */

    eph = (struct ether_hdr *)pkt;
    if(ntohs(eph->ether_type) != 0x0800) {
      ip_offset = 18;
    }

    iph = (struct ip_hdr *)(pkt + ip_offset);
    tcph = (struct tcp_hdr *)(pkt + ip_offset + 20);

    inet_ntop(AF_INET, &iph->ip_src, ip_src, INET_ADDRSTRLEN);
    inet_ntop(AF_INET, &iph->ip_dst, ip_dst, INET_ADDRSTRLEN);

    printf("{ \"time\": %lu,\n", packet_header.ts.tv_sec);
    printf(" \"src_ip\": \"%s\",\n", ip_src);
    printf(" \"dst_ip\": \"%s\",\n", ip_dst);
    printf(" \"src_port\": %u,\n", ntohs(tcph->th_sport));
    printf(" \"dst_port\": %u,\n", ntohs(tcph->th_dport));
    printf(" \"seq\": %u,\n", ntohl(tcph->th_seq));
    printf(" \"ack\": %u,\n", ntohl(tcph->th_ack));
    printf(" \"syn\": %d,\n", tcph->th_flags & TH_SYN);
    printf(" \"fin\": %d,\n", tcph->th_flags & TH_FIN);
    printf(" \"rst\": %d\n", tcph->th_flags & TH_RST);
    printf("}\n\n\n");

    /*
    printf("\nip %s -> %s\n", ip_src, ip_dst);
    printf("port %u -> %u\n", ntohs(tcph->th_sport), ntohs(tcph->th_dport));
    if(tcph->th_flags & TH_SYN) {
      printf("SYN\n");
    }
    if(tcph->th_flags & TH_FIN) {
      printf("FIN\n");
    }
    if(tcph->th_flags & TH_RST) {
      printf("RST\n");
    }

    
    printf("\n\n\n");
    */
  }

  printf("]\n");
}
