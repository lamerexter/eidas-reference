package eu.eidas.idp;

import eu.eidas.auth.commons.EIDASUtil;
import eu.eidas.auth.engine.metadata.MetadataSignerI;
import eu.eidas.auth.engine.metadata.impl.DefaultMetadataFetcher;
import eu.eidas.auth.engine.xml.opensaml.CertificateUtil;
import eu.eidas.config.impl.EnvironmentVariableSubstitutor;
import eu.eidas.engine.exceptions.EIDASSAMLEngineException;
import org.apache.commons.httpclient.params.HttpConnectionParams;
import org.apache.commons.httpclient.protocol.Protocol;
import org.apache.commons.httpclient.protocol.SecureProtocolSocketFactory;
import org.opensaml.DefaultBootstrap;
import org.opensaml.saml2.metadata.EntityDescriptor;
import org.opensaml.ws.soap.client.http.TLSProtocolSocketFactory;
import org.opensaml.xml.security.x509.tls.StrictHostnameVerifier;

import javax.annotation.Nonnull;
import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.SSLException;
import javax.net.ssl.SSLSession;
import javax.net.ssl.SSLSocket;
import javax.net.ssl.X509TrustManager;
import java.io.IOException;
import java.net.InetAddress;
import java.net.Socket;
import java.security.cert.X509Certificate;
import java.util.Properties;

/**
 * IdpMetadataFetcher
 *
 * @since 1.1
 */
public final class IdpMetadataFetcher extends DefaultMetadataFetcher {

    private final Properties idpProperties = new EnvironmentVariableSubstitutor().mutatePropertiesReplaceValues(EIDASUtil.loadConfigs(Constants.IDP_PROPERTIES));

    private String hubSslCertificateString = idpProperties.getProperty(Constants.HUB_SSL_CERT_BASE64);

    @Nonnull
    @Override
    public EntityDescriptor getEntityDescriptor(@Nonnull String url, @Nonnull MetadataSignerI metadataSigner)
            throws EIDASSAMLEngineException {
        boolean checkMetadata = idpProperties != null && Boolean.parseBoolean(idpProperties.getProperty(IDPUtil.ACTIVE_METADATA_CHECK));
        if (checkMetadata) {
            return super.getEntityDescriptor(url, metadataSigner);
        }
        return null;
    }

    @Override
    protected boolean mustUseHttps() {
        return false;
    }

    @Override
    protected boolean mustValidateSignature(@Nonnull String url) {
        return false;
    }

    /**
     * Override this method to plug your own SSLSocketFactory.
     * <p>
     * This default implementation relies on the default one from the JVM, i.e. using the default trustStore
     * ($JRE/lib/security/cacerts).
     *
     * @return the SecureProtocolSocketFactory instance to be used to connect to https metadata URLs.
     */
    @Nonnull
    @Override
    protected SecureProtocolSocketFactory newSslSocketFactory() {
        final SecureProtocolSocketFactory hubLocalSslCertificateProtocolSocketFactory = hubLocalSslSocketFactory();

        final SecureProtocolSocketFactory parentSslFactory = super.newSslSocketFactory();

        return new SecureProtocolSocketFactory() {
            @Override
            public Socket createSocket(Socket socket, String s, int i, boolean b) throws IOException {
                try {
                    return parentSslFactory.createSocket(socket, s, i, b);
                } catch (IOException e) {
                    return hubLocalSslCertificateProtocolSocketFactory.createSocket(socket, s, i, b);
                }
            }

            @Override
            public Socket createSocket(String s, int i, InetAddress inetAddress, int i1) throws IOException {
                try {
                    return parentSslFactory.createSocket(s, i, inetAddress, i1);
                } catch (IOException e) {
                    return hubLocalSslCertificateProtocolSocketFactory.createSocket(s, i, inetAddress, i1);
                }
            }

            @Override
            public Socket createSocket(String s, int i, InetAddress inetAddress, int i1, HttpConnectionParams httpConnectionParams) throws IOException {
                try {
                    return parentSslFactory.createSocket(s, i, inetAddress, i1, httpConnectionParams);
                } catch (IOException e) {
                    return hubLocalSslCertificateProtocolSocketFactory.createSocket(s, i, inetAddress, i1, httpConnectionParams);
                }
            }

            @Override
            public Socket createSocket(String s, int i) throws IOException {
                try {
                    return parentSslFactory.createSocket(s, i);
                } catch (IOException e) {
                    return hubLocalSslCertificateProtocolSocketFactory.createSocket(s, i);
                }
            }
        };

    }

    protected SecureProtocolSocketFactory hubLocalSslSocketFactory() {
        HostnameVerifier hostnameVerifier;

        if (!Boolean.getBoolean(DefaultBootstrap.SYSPROP_HTTPCLIENT_HTTPS_DISABLE_HOSTNAME_VERIFICATION)) {
            hostnameVerifier = new StrictHostnameVerifier();
        } else {
            hostnameVerifier = org.apache.commons.ssl.HostnameVerifier.ALLOW_ALL;
        }

        X509TrustManager trustedCertManager = new X509TrustManager() {
            @Override
            public java.security.cert.X509Certificate[] getAcceptedIssuers() {
                try {
                    return new X509Certificate[]{CertificateUtil.toCertificate(hubSslCertificateString)};
                } catch (EIDASSAMLEngineException e) {
                    throw new RuntimeException("Unable to load trusted certificate: ", e);
                }
            }

            @Override
            public void checkClientTrusted(java.security.cert.X509Certificate[] certs, String authType) {
            }

            @Override
            public void checkServerTrusted(java.security.cert.X509Certificate[] certs, String authType) {
            }
        };

        TLSProtocolSocketFactory tlsProtocolSocketFactory = new TLSProtocolSocketFactory(null, trustedCertManager, hostnameVerifier) {
            @Override
            protected void verifyHostname(Socket socket) throws SSLException {
                if (socket instanceof SSLSocket) {
                    SSLSocket sslSocket = (SSLSocket) socket;
                    try {
                        sslSocket.startHandshake();
                    } catch (IOException e) {
                        throw new SSLException(e);
                    }
                    SSLSession sslSession = sslSocket.getSession();
                    if (!sslSession.isValid()) {
                        throw new SSLException("SSLSession was invalid: Likely implicit handshake failure: "
                                + "Set system property javax.net.debug=all for details");
                    }
                    super.verifyHostname(sslSocket);
                }
            }
        };

        Protocol.registerProtocol("https", new Protocol("https", tlsProtocolSocketFactory, 443));

        return tlsProtocolSocketFactory;
    }

}
