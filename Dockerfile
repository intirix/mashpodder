FROM ubuntu:latest

# docker build -t intirix/mashpodder .

RUN apt-get update && apt-get install -y wget curl xsltproc
RUN useradd -u 2000 -m podcast && mkdir /home/podcast/podcasts

ADD *.sh /home/podcast/
ADD parse_enclosure.xsl /home/podcast/
ADD mp.conf /home/podcast/
RUN chmod 755 /home/podcast/*.sh && chown -R podcast /home/podcast/
VOLUME ["/home/podcast/podcasts"]

RUN echo "0   2  * * *    podcast BASEDIR=/home/podcast /home/podcast/sample-wrapper-for-cron.sh 2>&1 | logger -t mashpodder" >> /etc/crontab
cmd ["sh","-c","chown -R podcast /home/podcast/podcasts;cron;rsyslogd;cat /home/podcast/mp.conf;tail -F /var/log/syslog /home/podcast/permpodcastlog.txt"]
