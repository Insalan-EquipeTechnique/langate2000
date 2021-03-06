install:
	cp langate2000-netcontrol.service /etc/systemd/system/

copyconfig:
	cp config.py langate2000-netcontrol/
	cp config.py langate/langate/

build: copyconfig
	docker build . -t langate

run:
	systemctl start langate2000-netcontrol
	docker run -itd \
		--privileged -p 8000:8000 \
		--name langate \
		-v /var/www/html/static:/var/www/html/static \
		-v /var/run/langate2000-netcontrol.sock:/var/run/langate2000-netcontrol.sock\
		-v $(shell pwd)/langate:/app/langate \
		langate
	#@docker exec -it langate python3 manage.py createsuperuser

stop:
	docker stop langate
	docker rm langate

restart: stop run

builddev: copyconfig
	docker build -t langate-dev -f Dockerfile.dev .

rundev:
	docker run -itd --privileged -p 80:80 --name langate-dev langate-dev

stopdev:
	docker stop langate-dev
	docker rm langate-dev
