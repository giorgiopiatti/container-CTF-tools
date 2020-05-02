FROM ubuntu:bionic
ENV CTF_NAME = 'CTF-Tools(27)'
COPY ./tools_setup.sh /root/
COPY ./start.sh /root/
WORKDIR /root
RUN chmod +x ./start.sh ./tools_setup.sh

RUN ./tools_setup.sh
RUN chsh -s $(which zsh)
RUN echo 'PROMPT="%{$fg[green]%}%${CTF_NAME}%{$reset_color%} ${PROMPT}"' >> ~/.zshrc 
CMD ./start.sh