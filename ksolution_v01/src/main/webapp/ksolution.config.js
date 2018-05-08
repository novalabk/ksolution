var ksolution = {};
function KSModal () {
	
	var mask = new ax5.ui.mask();
    var modal = new ax5.ui.modal();
    
    var modalCallback = {};

    var defaultCss = {
        width: 400,
        height: 400,
        position: {
            left: "center",
            top: "middle"
        }
    };

    var defaultOption = $.extend(true, {}, defaultCss, {
        iframeLoadingMsg: "",
        iframe: {
            method: "post",
            url: "#"
        },
        closeToEsc: true,
        onStateChanged: function onStateChanged() {
            // mask
            if (this.state === "open") {
            	mask.open();
            } else if (this.state === "close") {
                mask.close();
            }
        },
        animateTime: 100,
        zIndex: 5000,
        absolute: true,
        fullScreen: false,
        header: {
            title: "&nbsp;",
            btns: {
//                minimize: {
//                    label: '<i class="cqc-circle-with-minus" aria-hidden="true"></i>', onClick: function(){
//                        modal.minimize();
//                    }
//                },
//                restore: {
//                    label: '<i class="cqc-circle-with-plus" aria-hidden="true"></i>', onClick: function(){
//                        modal.restore();
//                    }
//                },
                close: {
                    label: '<i class="cqc-circle-with-cross"></i>', 
                    onClick: function onClick() {
                        modal.close();
                    }
                }
            }
        }
    });

    /**
     * 지정한 조건으로 ax5 modal을 엽니다. modalConfig 를 넘기지 않으면 지정된 기본값으로 엽니다.
     * @method axboot.modal.open
     * @param {Object} modalConfig
     * @param {Number} modalConfig.width
     * @param {Number} modalConfig.height
     * @param {Object} modalConfig.position
     * @param {String} modalConfig.position.left
     * @param {String} modalConfig.position.top
     * @param {String} modalConfig.iframeLoadingMsg
     * @param {String} modalConfig.iframe.method
     * @param {String} modalConfig.iframe.url
     * @param {Boolean} modalConfig.closeToEsc
     * @param {Number} modalConfig.animateTime
     * @param {Number} modalConfig.zIndex
     * @param {Boolean} modalConfig.fullScreen
     * @param {Object} modalConfig.header
     * @param {String} modalConfig.header.title
     * @param {Function} modalConfig.sendData - 모달창에서 parent.axboot.modal.getData() 하여 호출합니다. 전달하고 싶은 변수를 return 하면 됩니다
     * @param {Function} modalConfig.callback - 모달창에서 parant.axboot.modal.callback() 으로 호출합니다.
     *
     * @example
     * ```js
     *  axboot.modal.open({
     *      width: 400,
     *      height: 400,
     *      header: false,
     *      iframe: {
     *          url: "open url"
     *          param: "param"
     *      },
     *      sendData: function(){
     *
     *      },
     *      callback: function(){
     *          axboot.modal.close();
     *      }
     *  });
     * ```
     */
    this.open = function open(modalConfig) {

        modalConfig = $.extend(true, {}, defaultOption, modalConfig);
        if (modalConfig.modalType) {

            if (axboot.def.MODAL && axboot.def.MODAL[modalConfig.modalType]) {
                if (modalConfig.param) {
                    $.extend(true, modalConfig, { iframe: { param: modalConfig.param } });
                }
                modalConfig = $.extend(true, {}, modalConfig, axboot.def.MODAL[modalConfig.modalType]);
            }
        }
        
        $(document.body).addClass("modalOpened");

        this.modalCallback = modalConfig.callback;
        this.modalSendData = modalConfig.sendData;

        modal.open(modalConfig);
    };

    /**
     * ax5 modal css 를 적용합니다.
     * @method axboot.modal.css
     * @param modalCss
     */
    this.css = function css(modalCss) {
        modalCss = $.extend(true, {}, defaultCss, modalCss);
        modal.css(modalCss);
    };
    /**
     * ax5 modal을 정렬합니다.
     * @method axboot.modal.align
     * @param modalAlign
     */
    this.align = function align(modalAlign) {
        modal.align(modalAlign);
    };
    /**
     * ax5 modal을 닫습니다.
     * @method axboot.modal.close
     */
    this.close = function close(data) {
        modal.close();
        setTimeout(function () {
            $(document.body).removeClass("modalOpened");
        }, 500);
    };
    /**
     * ax5 modal을 최소화 합니다.
     * @method axboot.modal.minimize
     */
    this.minimize = function minimize() {
        modal.minimize();
    };
    /**
     * ax5 modal을 최대화 합니다.
     * @methid axboot.modal.maximize
     */
    this.maximize = function maximize() {
        modal.maximize();
    };

    /**
     * callback 으로 정의된 함수에 전달된 파라메터를 넘겨줍니다.
     * @method axboot.modal.callback
     * @param {Object|String} data
     */
    this.callback = function callback(data) {
        if (this.modalCallback) {
            this.modalCallback(data);
        }
    };

    this.getData = function getData() {
        if (this.modalSendData) {
            return this.modalSendData();
        }
    };
};
