public class clsClippingReport {

    public String StrReportUrl { get; set; }
    public Integer IntChartCol { get; set; }
    public Integer IntChartRow { get; set; }

    String chartCol = '1';
    String chartRow = '0';

    public clsClippingReport(){        
    }

    Public String getReportHtml() {
        try {
            PageReference pageRef = new PageReference(StrReportUrl);
            return pageRef.getContent().toString();
        } catch(Exception e) {
            if(IntChartCol != null){
                chartCol = String.valueOf(IntChartCol).trim();
            }
            if(IntChartRow != null){
                chartRow = String.valueOf(IntChartRow).trim();
            }

            String errorHtml = '';

            errorHtml += '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">';
            errorHtml += '<html>';
            errorHtml += '<head>';
            errorHtml += '</head>';
            errorHtml += '<body>';
            errorHtml += '<div>';
            errorHtml += '    <div class="reportOutput">';
            errorHtml += '        <i>該当レポートは存在しません</i>';
            errorHtml += '    </div>';
            errorHtml += '</div>';
            errorHtml += '<div>';
            errorHtml += '    <table><tr>';
            errorHtml += '        <td class="col' + chartCol.trim() + '">';
            errorHtml += '            <div id="dashboard_0_' + chartRow.trim() + '">';
            errorHtml += '                <i>該当ダッシュボードは存在しません</i>';
            errorHtml += '            </div>';
            errorHtml += '        </td>';
            errorHtml += '    </tr></table>';
            errorHtml += '</div>';
            errorHtml += '</body>';
            errorHtml += '</html>';
            
            return errorHtml;
        }
    }

    public static testMethod void doTest(){
        clsClippingReport ctrl = new clsClippingReport();
        String StrReportUrl = '/home/home.jsp';
        ctrl.getReportHtml();
    }

}