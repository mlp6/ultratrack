




<!DOCTYPE html>
<html>
  <head prefix="og: http://ogp.me/ns# fb: http://ogp.me/ns/fb# object: http://ogp.me/ns/object# article: http://ogp.me/ns/article# profile: http://ogp.me/ns/profile#">
    <meta charset='utf-8'>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>ultratrack/sampledriver.m at master · Duke-Ultrasound/ultratrack</title>
    <link rel="search" type="application/opensearchdescription+xml" href="/opensearch.xml" title="GitHub" />
    <link rel="fluid-icon" href="https://github.com/fluidicon.png" title="GitHub" />
    <link rel="apple-touch-icon" sizes="57x57" href="/apple-touch-icon-114.png" />
    <link rel="apple-touch-icon" sizes="114x114" href="/apple-touch-icon-114.png" />
    <link rel="apple-touch-icon" sizes="72x72" href="/apple-touch-icon-144.png" />
    <link rel="apple-touch-icon" sizes="144x144" href="/apple-touch-icon-144.png" />
    <meta property="fb:app_id" content="1401488693436528"/>

      <meta content="@github" name="twitter:site" /><meta content="summary" name="twitter:card" /><meta content="Duke-Ultrasound/ultratrack" name="twitter:title" /><meta content="ultratrack - Field II ultrasonic displacement tracking code using FEM displacement fields" name="twitter:description" /><meta content="https://0.gravatar.com/avatar/49c55ca4002acafadc25c5c99e771730?d=https%3A%2F%2Fidenticons.github.com%2F57f9ed10a0cb861a4afaec64ba0fcbdd.png&amp;r=x&amp;s=400" name="twitter:image:src" />
<meta content="GitHub" property="og:site_name" /><meta content="object" property="og:type" /><meta content="https://0.gravatar.com/avatar/49c55ca4002acafadc25c5c99e771730?d=https%3A%2F%2Fidenticons.github.com%2F57f9ed10a0cb861a4afaec64ba0fcbdd.png&amp;r=x&amp;s=400" property="og:image" /><meta content="Duke-Ultrasound/ultratrack" property="og:title" /><meta content="https://github.com/Duke-Ultrasound/ultratrack" property="og:url" /><meta content="ultratrack - Field II ultrasonic displacement tracking code using FEM displacement fields" property="og:description" />

    <meta name="hostname" content="github-fe123-cp1-prd.iad.github.net">
    <meta name="ruby" content="ruby 2.1.0p0-github-tcmalloc (87d8860372) [x86_64-linux]">
    <link rel="assets" href="https://github.global.ssl.fastly.net/">
    <link rel="conduit-xhr" href="https://ghconduit.com:25035/">
    <link rel="xhr-socket" href="/_sockets" />


    <meta name="msapplication-TileImage" content="/windows-tile.png" />
    <meta name="msapplication-TileColor" content="#ffffff" />
    <meta name="selected-link" value="repo_source" data-pjax-transient />
    <meta content="collector.githubapp.com" name="octolytics-host" /><meta content="collector-cdn.github.com" name="octolytics-script-host" /><meta content="github" name="octolytics-app-id" /><meta content="98039F99:149B:322CC6:52FA560B" name="octolytics-dimension-request_id" /><meta content="3239175" name="octolytics-actor-id" /><meta content="mlp6" name="octolytics-actor-login" /><meta content="b4f60ec641f6a58f1dca6879062d861091374cf79ed8e252c9111b9b726ace9d" name="octolytics-actor-hash" />
    

    
    
    <link rel="icon" type="image/x-icon" href="/favicon.ico" />

    <meta content="authenticity_token" name="csrf-param" />
<meta content="opGZbI7qlkG+UoRMfscPeLTeF7VnHNDwkYt1GKzG8pY=" name="csrf-token" />

    <link href="https://github.global.ssl.fastly.net/assets/github-3edaf451c5611e17e1cd26dd9e684f8c2ff7cdab.css" media="all" rel="stylesheet" type="text/css" />
    <link href="https://github.global.ssl.fastly.net/assets/github2-456a392493f696a3779ecd85c4913acdef7d9507.css" media="all" rel="stylesheet" type="text/css" />
    


      <script src="https://github.global.ssl.fastly.net/assets/frameworks-141ccdd45eb970761fa7cacc2cb60ed9726dd738.js" type="text/javascript"></script>
      <script async="async" defer="defer" src="https://github.global.ssl.fastly.net/assets/github-b68d1e19c0b2aef3b0d249778034d8849a904f0e.js" type="text/javascript"></script>
      
      <meta http-equiv="x-pjax-version" content="b69b4a881f4921f927c68c221c42c1ee">

        <link data-pjax-transient rel='permalink' href='/Duke-Ultrasound/ultratrack/blob/ff6c056e13f0109ac7be5519afc5285d46254faa/sampledriver.m'>

  <meta name="description" content="ultratrack - Field II ultrasonic displacement tracking code using FEM displacement fields" />

  <meta content="5090522" name="octolytics-dimension-user_id" /><meta content="Duke-Ultrasound" name="octolytics-dimension-user_login" /><meta content="12389973" name="octolytics-dimension-repository_id" /><meta content="Duke-Ultrasound/ultratrack" name="octolytics-dimension-repository_nwo" /><meta content="false" name="octolytics-dimension-repository_public" /><meta content="false" name="octolytics-dimension-repository_is_fork" /><meta content="12389973" name="octolytics-dimension-repository_network_root_id" /><meta content="Duke-Ultrasound/ultratrack" name="octolytics-dimension-repository_network_root_nwo" />
  <link href="https://github.com/Duke-Ultrasound/ultratrack/commits/master.atom?token=3239175__eyJzY29wZSI6IkF0b206L0R1a2UtVWx0cmFzb3VuZC91bHRyYXRyYWNrL2NvbW1pdHMvbWFzdGVyLmF0b20iLCJleHBpcmVzIjoyOTY5OTc0NTQzfQ==--c2501af2f707a78269816dcd276c50ef4aa3cd10" rel="alternate" title="Recent Commits to ultratrack:master" type="application/atom+xml" />

  </head>


  <body class="logged_in  env-production linux vis-private page-blob">
    <div class="wrapper">
      
      
      
      


      <div class="header header-logged-in true">
  <div class="container clearfix">

    <a class="header-logo-invertocat" href="https://github.com/">
  <span class="mega-octicon octicon-mark-github"></span>
</a>

    
    <a href="/notifications" class="notification-indicator tooltipped downwards" data-gotokey="n" title="You have unread notifications">
        <span class="mail-status unread"></span>
</a>

      <div class="command-bar js-command-bar  in-repository">
          <form accept-charset="UTF-8" action="/search" class="command-bar-form" id="top_search_form" method="get">

<input type="text" data-hotkey="/ s" name="q" id="js-command-bar-field" placeholder="Search or type a command" tabindex="1" autocapitalize="off"
    
    data-username="mlp6"
      data-repo="Duke-Ultrasound/ultratrack"
      data-branch="master"
      data-sha="4df5b724a30103c4f2db7e36585b1c3ee8bb0aa8"
  >

    <input type="hidden" name="nwo" value="Duke-Ultrasound/ultratrack" />

    <div class="select-menu js-menu-container js-select-menu search-context-select-menu">
      <span class="minibutton select-menu-button js-menu-target">
        <span class="js-select-button">This repository</span>
      </span>

      <div class="select-menu-modal-holder js-menu-content js-navigation-container">
        <div class="select-menu-modal">

          <div class="select-menu-item js-navigation-item js-this-repository-navigation-item selected">
            <span class="select-menu-item-icon octicon octicon-check"></span>
            <input type="radio" class="js-search-this-repository" name="search_target" value="repository" checked="checked" />
            <div class="select-menu-item-text js-select-button-text">This repository</div>
          </div> <!-- /.select-menu-item -->

          <div class="select-menu-item js-navigation-item js-all-repositories-navigation-item">
            <span class="select-menu-item-icon octicon octicon-check"></span>
            <input type="radio" name="search_target" value="global" />
            <div class="select-menu-item-text js-select-button-text">All repositories</div>
          </div> <!-- /.select-menu-item -->

        </div>
      </div>
    </div>

  <span class="octicon help tooltipped downwards" title="Show command bar help">
    <span class="octicon octicon-question"></span>
  </span>


  <input type="hidden" name="ref" value="cmdform">

</form>
        <ul class="top-nav">
          <li class="explore"><a href="/explore">Explore</a></li>
            <li><a href="https://gist.github.com">Gist</a></li>
            <li><a href="/blog">Blog</a></li>
          <li><a href="https://help.github.com">Help</a></li>
        </ul>
      </div>

    


  <ul id="user-links">
    <li>
      <a href="/mlp6" class="name">
        <img alt="Mark Palmeri" class=" js-avatar" data-user="3239175" height="20" src="https://2.gravatar.com/avatar/e0bad950af2bc37c7dee49240e1ffc88?d=https%3A%2F%2Fidenticons.github.com%2Febd2689bdf687fa855a261a9b9cd1ee0.png&amp;r=x&amp;s=140" width="20" /> mlp6
      </a>
    </li>

    <li class="new-menu dropdown-toggle js-menu-container">
      <a href="#" class="js-menu-target tooltipped downwards" title="Create new..." aria-label="Create new...">
        <span class="octicon octicon-plus"></span>
        <span class="dropdown-arrow"></span>
      </a>

      <div class="js-menu-content">
      </div>
    </li>

    <li>
      <a href="/settings/profile" id="account_settings"
        class="tooltipped downwards"
        aria-label="Account settings "
        title="Account settings ">
        <span class="octicon octicon-tools"></span>
      </a>
    </li>
    <li>
      <a class="tooltipped downwards" href="/logout" data-method="post" id="logout" title="Sign out" aria-label="Sign out">
        <span class="octicon octicon-log-out"></span>
      </a>
    </li>

  </ul>

<div class="js-new-dropdown-contents hidden">
  

<ul class="dropdown-menu">
  <li>
    <a href="/new"><span class="octicon octicon-repo-create"></span> New repository</a>
  </li>
  <li>
    <a href="/organizations/new"><span class="octicon octicon-organization"></span> New organization</a>
  </li>
    <li class="section-title">
      <span title="Duke-Ultrasound">This organization</span>
    </li>
      <li>
        <a href="/orgs/Duke-Ultrasound/members/new"><span class="octicon octicon-person-add"></span> New member</a>
      </li>
    <li>
      <a href="/orgs/Duke-Ultrasound/new-team"><span class="octicon octicon-jersey"></span> New team</a>
    </li>
    <li>
      <a href="/organizations/Duke-Ultrasound/repositories/new"><span class="octicon octicon-repo-create"></span> New repository</a>
    </li>


    <li class="section-title">
      <span title="Duke-Ultrasound/ultratrack">This repository</span>
    </li>
      <li>
        <a href="/Duke-Ultrasound/ultratrack/issues/new"><span class="octicon octicon-issue-opened"></span> New issue</a>
      </li>
      <li>
        <a href="/Duke-Ultrasound/ultratrack/settings/collaboration"><span class="octicon octicon-person-add"></span> New collaborator</a>
      </li>
</ul>

</div>


    
  </div>
</div>

      

      




          <div class="site" itemscope itemtype="http://schema.org/WebPage">
    
    <div class="pagehead repohead instapaper_ignore readability-menu">
      <div class="container">
        

<ul class="pagehead-actions">

    <li class="subscription">
      <form accept-charset="UTF-8" action="/notifications/subscribe" class="js-social-container" data-autosubmit="true" data-remote="true" method="post"><div style="margin:0;padding:0;display:inline"><input name="authenticity_token" type="hidden" value="opGZbI7qlkG+UoRMfscPeLTeF7VnHNDwkYt1GKzG8pY=" /></div>  <input id="repository_id" name="repository_id" type="hidden" value="12389973" />

    <div class="select-menu js-menu-container js-select-menu">
      <a class="social-count js-social-count" href="/Duke-Ultrasound/ultratrack/watchers">
        17
      </a>
      <span class="minibutton select-menu-button with-count js-menu-target" role="button" tabindex="0">
        <span class="js-select-button">
          <span class="octicon octicon-eye-unwatch"></span>
          Unwatch
        </span>
      </span>

      <div class="select-menu-modal-holder">
        <div class="select-menu-modal subscription-menu-modal js-menu-content">
          <div class="select-menu-header">
            <span class="select-menu-title">Notification status</span>
            <span class="octicon octicon-remove-close js-menu-close"></span>
          </div> <!-- /.select-menu-header -->

          <div class="select-menu-list js-navigation-container" role="menu">

            <div class="select-menu-item js-navigation-item " role="menuitem" tabindex="0">
              <span class="select-menu-item-icon octicon octicon-check"></span>
              <div class="select-menu-item-text">
                <input id="do_included" name="do" type="radio" value="included" />
                <h4>Not watching</h4>
                <span class="description">You only receive notifications for conversations in which you participate or are @mentioned.</span>
                <span class="js-select-button-text hidden-select-button-text">
                  <span class="octicon octicon-eye-watch"></span>
                  Watch
                </span>
              </div>
            </div> <!-- /.select-menu-item -->

            <div class="select-menu-item js-navigation-item selected" role="menuitem" tabindex="0">
              <span class="select-menu-item-icon octicon octicon octicon-check"></span>
              <div class="select-menu-item-text">
                <input checked="checked" id="do_subscribed" name="do" type="radio" value="subscribed" />
                <h4>Watching</h4>
                <span class="description">You receive notifications for all conversations in this repository.</span>
                <span class="js-select-button-text hidden-select-button-text">
                  <span class="octicon octicon-eye-unwatch"></span>
                  Unwatch
                </span>
              </div>
            </div> <!-- /.select-menu-item -->

            <div class="select-menu-item js-navigation-item " role="menuitem" tabindex="0">
              <span class="select-menu-item-icon octicon octicon-check"></span>
              <div class="select-menu-item-text">
                <input id="do_ignore" name="do" type="radio" value="ignore" />
                <h4>Ignoring</h4>
                <span class="description">You do not receive any notifications for conversations in this repository.</span>
                <span class="js-select-button-text hidden-select-button-text">
                  <span class="octicon octicon-mute"></span>
                  Stop ignoring
                </span>
              </div>
            </div> <!-- /.select-menu-item -->

          </div> <!-- /.select-menu-list -->

        </div> <!-- /.select-menu-modal -->
      </div> <!-- /.select-menu-modal-holder -->
    </div> <!-- /.select-menu -->

</form>
    </li>

  <li>
  

  <div class="js-toggler-container js-social-container starring-container ">
    <a href="/Duke-Ultrasound/ultratrack/unstar"
      class="minibutton with-count js-toggler-target star-button starred upwards"
      title="Unstar this repository" data-remote="true" data-method="post" rel="nofollow">
      <span class="octicon octicon-star-delete"></span><span class="text">Unstar</span>
    </a>

    <a href="/Duke-Ultrasound/ultratrack/star"
      class="minibutton with-count js-toggler-target star-button unstarred upwards"
      title="Star this repository" data-remote="true" data-method="post" rel="nofollow">
      <span class="octicon octicon-star"></span><span class="text">Star</span>
    </a>

      <a class="social-count js-social-count" href="/Duke-Ultrasound/ultratrack/stargazers">
        0
      </a>
  </div>

  </li>


        <li>
          <a href="/Duke-Ultrasound/ultratrack/fork" class="minibutton with-count js-toggler-target fork-button lighter upwards" title="Fork this repo" rel="facebox nofollow">
            <span class="octicon octicon-git-branch-create"></span><span class="text">Fork</span>
          </a>
          <a href="/Duke-Ultrasound/ultratrack/network" class="social-count">0</a>
        </li>


</ul>

        <h1 itemscope itemtype="http://data-vocabulary.org/Breadcrumb" class="entry-title private">
          <span class="repo-label"><span>private</span></span>
          <span class="mega-octicon octicon-lock"></span>
          <span class="author">
            <a href="/Duke-Ultrasound" class="url fn" itemprop="url" rel="author"><span itemprop="title">Duke-Ultrasound</span></a>
          </span>
          <span class="repohead-name-divider">/</span>
          <strong><a href="/Duke-Ultrasound/ultratrack" class="js-current-repository js-repo-home-link">ultratrack</a></strong>

          <span class="page-context-loader">
            <img alt="Octocat-spinner-32" height="16" src="https://github.global.ssl.fastly.net/images/spinners/octocat-spinner-32.gif" width="16" />
          </span>

        </h1>
      </div><!-- /.container -->
    </div><!-- /.repohead -->

    <div class="container">
      

      <div class="repository-with-sidebar repo-container new-discussion-timeline js-new-discussion-timeline  ">
        <div class="repository-sidebar">
            

<div class="sunken-menu vertical-right repo-nav js-repo-nav js-repository-container-pjax js-octicon-loaders">
  <div class="sunken-menu-contents">
    <ul class="sunken-menu-group">
      <li class="tooltipped leftwards" title="Code">
        <a href="/Duke-Ultrasound/ultratrack" aria-label="Code" class="selected js-selected-navigation-item sunken-menu-item" data-gotokey="c" data-pjax="true" data-selected-links="repo_source repo_downloads repo_commits repo_tags repo_branches /Duke-Ultrasound/ultratrack">
          <span class="octicon octicon-code"></span> <span class="full-word">Code</span>
          <img alt="Octocat-spinner-32" class="mini-loader" height="16" src="https://github.global.ssl.fastly.net/images/spinners/octocat-spinner-32.gif" width="16" />
</a>      </li>

        <li class="tooltipped leftwards" title="Issues">
          <a href="/Duke-Ultrasound/ultratrack/issues" aria-label="Issues" class="js-selected-navigation-item sunken-menu-item js-disable-pjax" data-gotokey="i" data-selected-links="repo_issues /Duke-Ultrasound/ultratrack/issues">
            <span class="octicon octicon-issue-opened"></span> <span class="full-word">Issues</span>
            <span class='counter'>7</span>
            <img alt="Octocat-spinner-32" class="mini-loader" height="16" src="https://github.global.ssl.fastly.net/images/spinners/octocat-spinner-32.gif" width="16" />
</a>        </li>

      <li class="tooltipped leftwards" title="Pull Requests">
        <a href="/Duke-Ultrasound/ultratrack/pulls" aria-label="Pull Requests" class="js-selected-navigation-item sunken-menu-item js-disable-pjax" data-gotokey="p" data-selected-links="repo_pulls /Duke-Ultrasound/ultratrack/pulls">
            <span class="octicon octicon-git-pull-request"></span> <span class="full-word">Pull Requests</span>
            <span class='counter'>0</span>
            <img alt="Octocat-spinner-32" class="mini-loader" height="16" src="https://github.global.ssl.fastly.net/images/spinners/octocat-spinner-32.gif" width="16" />
</a>      </li>


        <li class="tooltipped leftwards" title="Wiki">
          <a href="/Duke-Ultrasound/ultratrack/wiki" aria-label="Wiki" class="js-selected-navigation-item sunken-menu-item" data-pjax="true" data-selected-links="repo_wiki /Duke-Ultrasound/ultratrack/wiki">
            <span class="octicon octicon-book"></span> <span class="full-word">Wiki</span>
            <img alt="Octocat-spinner-32" class="mini-loader" height="16" src="https://github.global.ssl.fastly.net/images/spinners/octocat-spinner-32.gif" width="16" />
</a>        </li>
    </ul>
    <div class="sunken-menu-separator"></div>
    <ul class="sunken-menu-group">

      <li class="tooltipped leftwards" title="Pulse">
        <a href="/Duke-Ultrasound/ultratrack/pulse" aria-label="Pulse" class="js-selected-navigation-item sunken-menu-item" data-pjax="true" data-selected-links="pulse /Duke-Ultrasound/ultratrack/pulse">
          <span class="octicon octicon-pulse"></span> <span class="full-word">Pulse</span>
          <img alt="Octocat-spinner-32" class="mini-loader" height="16" src="https://github.global.ssl.fastly.net/images/spinners/octocat-spinner-32.gif" width="16" />
</a>      </li>

      <li class="tooltipped leftwards" title="Graphs">
        <a href="/Duke-Ultrasound/ultratrack/graphs" aria-label="Graphs" class="js-selected-navigation-item sunken-menu-item" data-pjax="true" data-selected-links="repo_graphs repo_contributors /Duke-Ultrasound/ultratrack/graphs">
          <span class="octicon octicon-graph"></span> <span class="full-word">Graphs</span>
          <img alt="Octocat-spinner-32" class="mini-loader" height="16" src="https://github.global.ssl.fastly.net/images/spinners/octocat-spinner-32.gif" width="16" />
</a>      </li>

      <li class="tooltipped leftwards" title="Network">
        <a href="/Duke-Ultrasound/ultratrack/network" aria-label="Network" class="js-selected-navigation-item sunken-menu-item js-disable-pjax" data-selected-links="repo_network /Duke-Ultrasound/ultratrack/network">
          <span class="octicon octicon-git-branch"></span> <span class="full-word">Network</span>
          <img alt="Octocat-spinner-32" class="mini-loader" height="16" src="https://github.global.ssl.fastly.net/images/spinners/octocat-spinner-32.gif" width="16" />
</a>      </li>
    </ul>


      <div class="sunken-menu-separator"></div>
      <ul class="sunken-menu-group">
        <li class="tooltipped leftwards" title="Settings">
          <a href="/Duke-Ultrasound/ultratrack/settings"
            class="sunken-menu-item" data-pjax aria-label="Settings">
            <span class="octicon octicon-tools"></span> <span class="full-word">Settings</span>
            <img alt="Octocat-spinner-32" class="mini-loader" height="16" src="https://github.global.ssl.fastly.net/images/spinners/octocat-spinner-32.gif" width="16" />
          </a>
        </li>
      </ul>
  </div>
</div>

              <div class="only-with-full-nav">
                

  

<div class="clone-url open"
  data-protocol-type="http"
  data-url="/users/set_protocol?protocol_selector=http&amp;protocol_type=push">
  <h3><strong>HTTPS</strong> clone URL</h3>
  <div class="clone-url-box">
    <input type="text" class="clone js-url-field"
           value="https://github.com/Duke-Ultrasound/ultratrack.git" readonly="readonly">

    <span class="js-zeroclipboard url-box-clippy minibutton zeroclipboard-button" data-clipboard-text="https://github.com/Duke-Ultrasound/ultratrack.git" data-copied-hint="copied!" title="copy to clipboard"><span class="octicon octicon-clippy"></span></span>
  </div>
</div>

  

<div class="clone-url "
  data-protocol-type="ssh"
  data-url="/users/set_protocol?protocol_selector=ssh&amp;protocol_type=push">
  <h3><strong>SSH</strong> clone URL</h3>
  <div class="clone-url-box">
    <input type="text" class="clone js-url-field"
           value="git@github.com:Duke-Ultrasound/ultratrack.git" readonly="readonly">

    <span class="js-zeroclipboard url-box-clippy minibutton zeroclipboard-button" data-clipboard-text="git@github.com:Duke-Ultrasound/ultratrack.git" data-copied-hint="copied!" title="copy to clipboard"><span class="octicon octicon-clippy"></span></span>
  </div>
</div>

  

<div class="clone-url "
  data-protocol-type="subversion"
  data-url="/users/set_protocol?protocol_selector=subversion&amp;protocol_type=push">
  <h3><strong>Subversion</strong> checkout URL</h3>
  <div class="clone-url-box">
    <input type="text" class="clone js-url-field"
           value="https://github.com/Duke-Ultrasound/ultratrack" readonly="readonly">

    <span class="js-zeroclipboard url-box-clippy minibutton zeroclipboard-button" data-clipboard-text="https://github.com/Duke-Ultrasound/ultratrack" data-copied-hint="copied!" title="copy to clipboard"><span class="octicon octicon-clippy"></span></span>
  </div>
</div>


<p class="clone-options">You can clone with
      <a href="#" class="js-clone-selector" data-protocol="http">HTTPS</a>,
      <a href="#" class="js-clone-selector" data-protocol="ssh">SSH</a>,
      or <a href="#" class="js-clone-selector" data-protocol="subversion">Subversion</a>.
  <span class="octicon help tooltipped upwards" title="Get help on which URL is right for you.">
    <a href="https://help.github.com/articles/which-remote-url-should-i-use">
    <span class="octicon octicon-question"></span>
    </a>
  </span>
</p>



                <a href="/Duke-Ultrasound/ultratrack/archive/master.zip"
                   class="minibutton sidebar-button"
                   title="Download this repository as a zip file"
                   rel="nofollow">
                  <span class="octicon octicon-cloud-download"></span>
                  Download ZIP
                </a>
              </div>
        </div><!-- /.repository-sidebar -->

        <div id="js-repo-pjax-container" class="repository-content context-loader-container" data-pjax-container>
          


<!-- blob contrib key: blob_contributors:v21:94b55d52dc6eb4b3d8138ad03609bb0c -->

<p title="This is a placeholder element" class="js-history-link-replace hidden"></p>

<a href="/Duke-Ultrasound/ultratrack/find/master" data-pjax data-hotkey="t" class="js-show-file-finder" style="display:none">Show File Finder</a>

<div class="file-navigation">
  

<div class="select-menu js-menu-container js-select-menu" >
  <span class="minibutton select-menu-button js-menu-target" data-hotkey="w"
    data-master-branch="master"
    data-ref="master"
    role="button" aria-label="Switch branches or tags" tabindex="0">
    <span class="octicon octicon-git-branch"></span>
    <i>branch:</i>
    <span class="js-select-button">master</span>
  </span>

  <div class="select-menu-modal-holder js-menu-content js-navigation-container" data-pjax>

    <div class="select-menu-modal">
      <div class="select-menu-header">
        <span class="select-menu-title">Switch branches/tags</span>
        <span class="octicon octicon-remove-close js-menu-close"></span>
      </div> <!-- /.select-menu-header -->

      <div class="select-menu-filters">
        <div class="select-menu-text-filter">
          <input type="text" aria-label="Find or create a branch…" id="context-commitish-filter-field" class="js-filterable-field js-navigation-enable" placeholder="Find or create a branch…">
        </div>
        <div class="select-menu-tabs">
          <ul>
            <li class="select-menu-tab">
              <a href="#" data-tab-filter="branches" class="js-select-menu-tab">Branches</a>
            </li>
            <li class="select-menu-tab">
              <a href="#" data-tab-filter="tags" class="js-select-menu-tab">Tags</a>
            </li>
          </ul>
        </div><!-- /.select-menu-tabs -->
      </div><!-- /.select-menu-filters -->

      <div class="select-menu-list select-menu-tab-bucket js-select-menu-tab-bucket" data-tab-filter="branches">

        <div data-filterable-for="context-commitish-filter-field" data-filterable-type="substring">


            <div class="select-menu-item js-navigation-item selected">
              <span class="select-menu-item-icon octicon octicon-check"></span>
              <a href="/Duke-Ultrasound/ultratrack/blob/master/sampledriver.m"
                 data-name="master"
                 data-skip-pjax="true"
                 rel="nofollow"
                 class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target"
                 title="master">master</a>
            </div> <!-- /.select-menu-item -->
        </div>

          <form accept-charset="UTF-8" action="/Duke-Ultrasound/ultratrack/branches" class="js-create-branch select-menu-item select-menu-new-item-form js-navigation-item js-new-item-form" method="post"><div style="margin:0;padding:0;display:inline"><input name="authenticity_token" type="hidden" value="opGZbI7qlkG+UoRMfscPeLTeF7VnHNDwkYt1GKzG8pY=" /></div>
            <span class="octicon octicon-git-branch-create select-menu-item-icon"></span>
            <div class="select-menu-item-text">
              <h4>Create branch: <span class="js-new-item-name"></span></h4>
              <span class="description">from ‘master’</span>
            </div>
            <input type="hidden" name="name" id="name" class="js-new-item-value">
            <input type="hidden" name="branch" id="branch" value="master" />
            <input type="hidden" name="path" id="path" value="sampledriver.m" />
          </form> <!-- /.select-menu-item -->

      </div> <!-- /.select-menu-list -->

      <div class="select-menu-list select-menu-tab-bucket js-select-menu-tab-bucket" data-tab-filter="tags">
        <div data-filterable-for="context-commitish-filter-field" data-filterable-type="substring">


        </div>

        <div class="select-menu-no-results">Nothing to show</div>
      </div> <!-- /.select-menu-list -->

    </div> <!-- /.select-menu-modal -->
  </div> <!-- /.select-menu-modal-holder -->
</div> <!-- /.select-menu -->

  <div class="breadcrumb">
    <span class='repo-root js-repo-root'><span itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><a href="/Duke-Ultrasound/ultratrack" data-branch="master" data-direction="back" data-pjax="true" itemscope="url"><span itemprop="title">ultratrack</span></a></span></span><span class="separator"> / </span><strong class="final-path">sampledriver.m</strong> <span class="js-zeroclipboard minibutton zeroclipboard-button" data-clipboard-text="sampledriver.m" data-copied-hint="copied!" title="copy to clipboard"><span class="octicon octicon-clippy"></span></span>
  </div>
</div>


  <div class="commit file-history-tease">
    <img alt="Mark Palmeri" class="main-avatar js-avatar" data-user="3239175" height="24" src="https://2.gravatar.com/avatar/e0bad950af2bc37c7dee49240e1ffc88?d=https%3A%2F%2Fidenticons.github.com%2Febd2689bdf687fa855a261a9b9cd1ee0.png&amp;r=x&amp;s=140" width="24" />
    <span class="author"><a href="/mlp6" rel="author">mlp6</a></span>
    <time class="js-relative-date" data-title-format="YYYY-MM-DD HH:mm:ss" datetime="2013-04-22T20:27:41-07:00" title="2013-04-22 20:27:41">April 22, 2013</time>
    <div class="commit-title">
        <a href="/Duke-Ultrasound/ultratrack/commit/bf685a9daf0fdee069c97e4a20214c6e6578a3b3" class="message" data-pjax="true" title="moved all previous tags to tags directory and started 2.6.1 as master">moved all previous tags to tags directory and started 2.6.1 as master</a>
    </div>

    <div class="participation">
      <p class="quickstat"><a href="#blob_contributors_box" rel="facebox"><strong>1</strong> contributor</a></p>
      
    </div>
    <div id="blob_contributors_box" style="display:none">
      <h2 class="facebox-header">Users who have contributed to this file</h2>
      <ul class="facebox-user-list">
          <li class="facebox-user-list-item">
            <img alt="Mark Palmeri" class=" js-avatar" data-user="3239175" height="24" src="https://2.gravatar.com/avatar/e0bad950af2bc37c7dee49240e1ffc88?d=https%3A%2F%2Fidenticons.github.com%2Febd2689bdf687fa855a261a9b9cd1ee0.png&amp;r=x&amp;s=140" width="24" />
            <a href="/mlp6">mlp6</a>
          </li>
      </ul>
    </div>
  </div>

<div id="files" class="bubble">
  <div class="file">
    <div class="meta">
      <div class="info">
        <span class="icon"><b class="octicon octicon-file-text"></b></span>
        <span class="mode" title="File Mode">file</span>
          <span>156 lines (135 sloc)</span>
        <span>6.419 kb</span>
      </div>
      <div class="actions">
        <div class="button-group">
                <a class="minibutton js-update-url-with-hash"
                   href="/Duke-Ultrasound/ultratrack/edit/master/sampledriver.m"
                   data-method="post" rel="nofollow" data-hotkey="e">Edit</a>
          <a href="/Duke-Ultrasound/ultratrack/raw/master/sampledriver.m" class="button minibutton " id="raw-url">Raw</a>
            <a href="/Duke-Ultrasound/ultratrack/blame/master/sampledriver.m" class="button minibutton js-update-url-with-hash">Blame</a>
          <a href="/Duke-Ultrasound/ultratrack/commits/master/sampledriver.m" class="button minibutton " rel="nofollow">History</a>
        </div><!-- /.button-group -->
          <a class="minibutton danger empty-icon tooltipped downwards"
             href="/Duke-Ultrasound/ultratrack/delete/master/sampledriver.m"
             title=""
             data-method="post" data-test-id="delete-blob-file" rel="nofollow">
          Delete
        </a>
      </div><!-- /.actions -->
    </div>
        <div class="blob-wrapper data type-matlab js-blob-data">
        <table class="file-code file-diff tab-size-8">
          <tr class="file-code-line">
            <td class="blob-line-nums">
              <span id="L1" rel="#L1">1</span>
<span id="L2" rel="#L2">2</span>
<span id="L3" rel="#L3">3</span>
<span id="L4" rel="#L4">4</span>
<span id="L5" rel="#L5">5</span>
<span id="L6" rel="#L6">6</span>
<span id="L7" rel="#L7">7</span>
<span id="L8" rel="#L8">8</span>
<span id="L9" rel="#L9">9</span>
<span id="L10" rel="#L10">10</span>
<span id="L11" rel="#L11">11</span>
<span id="L12" rel="#L12">12</span>
<span id="L13" rel="#L13">13</span>
<span id="L14" rel="#L14">14</span>
<span id="L15" rel="#L15">15</span>
<span id="L16" rel="#L16">16</span>
<span id="L17" rel="#L17">17</span>
<span id="L18" rel="#L18">18</span>
<span id="L19" rel="#L19">19</span>
<span id="L20" rel="#L20">20</span>
<span id="L21" rel="#L21">21</span>
<span id="L22" rel="#L22">22</span>
<span id="L23" rel="#L23">23</span>
<span id="L24" rel="#L24">24</span>
<span id="L25" rel="#L25">25</span>
<span id="L26" rel="#L26">26</span>
<span id="L27" rel="#L27">27</span>
<span id="L28" rel="#L28">28</span>
<span id="L29" rel="#L29">29</span>
<span id="L30" rel="#L30">30</span>
<span id="L31" rel="#L31">31</span>
<span id="L32" rel="#L32">32</span>
<span id="L33" rel="#L33">33</span>
<span id="L34" rel="#L34">34</span>
<span id="L35" rel="#L35">35</span>
<span id="L36" rel="#L36">36</span>
<span id="L37" rel="#L37">37</span>
<span id="L38" rel="#L38">38</span>
<span id="L39" rel="#L39">39</span>
<span id="L40" rel="#L40">40</span>
<span id="L41" rel="#L41">41</span>
<span id="L42" rel="#L42">42</span>
<span id="L43" rel="#L43">43</span>
<span id="L44" rel="#L44">44</span>
<span id="L45" rel="#L45">45</span>
<span id="L46" rel="#L46">46</span>
<span id="L47" rel="#L47">47</span>
<span id="L48" rel="#L48">48</span>
<span id="L49" rel="#L49">49</span>
<span id="L50" rel="#L50">50</span>
<span id="L51" rel="#L51">51</span>
<span id="L52" rel="#L52">52</span>
<span id="L53" rel="#L53">53</span>
<span id="L54" rel="#L54">54</span>
<span id="L55" rel="#L55">55</span>
<span id="L56" rel="#L56">56</span>
<span id="L57" rel="#L57">57</span>
<span id="L58" rel="#L58">58</span>
<span id="L59" rel="#L59">59</span>
<span id="L60" rel="#L60">60</span>
<span id="L61" rel="#L61">61</span>
<span id="L62" rel="#L62">62</span>
<span id="L63" rel="#L63">63</span>
<span id="L64" rel="#L64">64</span>
<span id="L65" rel="#L65">65</span>
<span id="L66" rel="#L66">66</span>
<span id="L67" rel="#L67">67</span>
<span id="L68" rel="#L68">68</span>
<span id="L69" rel="#L69">69</span>
<span id="L70" rel="#L70">70</span>
<span id="L71" rel="#L71">71</span>
<span id="L72" rel="#L72">72</span>
<span id="L73" rel="#L73">73</span>
<span id="L74" rel="#L74">74</span>
<span id="L75" rel="#L75">75</span>
<span id="L76" rel="#L76">76</span>
<span id="L77" rel="#L77">77</span>
<span id="L78" rel="#L78">78</span>
<span id="L79" rel="#L79">79</span>
<span id="L80" rel="#L80">80</span>
<span id="L81" rel="#L81">81</span>
<span id="L82" rel="#L82">82</span>
<span id="L83" rel="#L83">83</span>
<span id="L84" rel="#L84">84</span>
<span id="L85" rel="#L85">85</span>
<span id="L86" rel="#L86">86</span>
<span id="L87" rel="#L87">87</span>
<span id="L88" rel="#L88">88</span>
<span id="L89" rel="#L89">89</span>
<span id="L90" rel="#L90">90</span>
<span id="L91" rel="#L91">91</span>
<span id="L92" rel="#L92">92</span>
<span id="L93" rel="#L93">93</span>
<span id="L94" rel="#L94">94</span>
<span id="L95" rel="#L95">95</span>
<span id="L96" rel="#L96">96</span>
<span id="L97" rel="#L97">97</span>
<span id="L98" rel="#L98">98</span>
<span id="L99" rel="#L99">99</span>
<span id="L100" rel="#L100">100</span>
<span id="L101" rel="#L101">101</span>
<span id="L102" rel="#L102">102</span>
<span id="L103" rel="#L103">103</span>
<span id="L104" rel="#L104">104</span>
<span id="L105" rel="#L105">105</span>
<span id="L106" rel="#L106">106</span>
<span id="L107" rel="#L107">107</span>
<span id="L108" rel="#L108">108</span>
<span id="L109" rel="#L109">109</span>
<span id="L110" rel="#L110">110</span>
<span id="L111" rel="#L111">111</span>
<span id="L112" rel="#L112">112</span>
<span id="L113" rel="#L113">113</span>
<span id="L114" rel="#L114">114</span>
<span id="L115" rel="#L115">115</span>
<span id="L116" rel="#L116">116</span>
<span id="L117" rel="#L117">117</span>
<span id="L118" rel="#L118">118</span>
<span id="L119" rel="#L119">119</span>
<span id="L120" rel="#L120">120</span>
<span id="L121" rel="#L121">121</span>
<span id="L122" rel="#L122">122</span>
<span id="L123" rel="#L123">123</span>
<span id="L124" rel="#L124">124</span>
<span id="L125" rel="#L125">125</span>
<span id="L126" rel="#L126">126</span>
<span id="L127" rel="#L127">127</span>
<span id="L128" rel="#L128">128</span>
<span id="L129" rel="#L129">129</span>
<span id="L130" rel="#L130">130</span>
<span id="L131" rel="#L131">131</span>
<span id="L132" rel="#L132">132</span>
<span id="L133" rel="#L133">133</span>
<span id="L134" rel="#L134">134</span>
<span id="L135" rel="#L135">135</span>
<span id="L136" rel="#L136">136</span>
<span id="L137" rel="#L137">137</span>
<span id="L138" rel="#L138">138</span>
<span id="L139" rel="#L139">139</span>
<span id="L140" rel="#L140">140</span>
<span id="L141" rel="#L141">141</span>
<span id="L142" rel="#L142">142</span>
<span id="L143" rel="#L143">143</span>
<span id="L144" rel="#L144">144</span>
<span id="L145" rel="#L145">145</span>
<span id="L146" rel="#L146">146</span>
<span id="L147" rel="#L147">147</span>
<span id="L148" rel="#L148">148</span>
<span id="L149" rel="#L149">149</span>
<span id="L150" rel="#L150">150</span>
<span id="L151" rel="#L151">151</span>
<span id="L152" rel="#L152">152</span>
<span id="L153" rel="#L153">153</span>
<span id="L154" rel="#L154">154</span>
<span id="L155" rel="#L155">155</span>

            </td>
            <td class="blob-line-code"><div class="code-body highlight"><pre><div class='line' id='LC1'><span class="k">function</span><span class="w"> </span>[]<span class="p">=</span><span class="nf">ultratrack260</span><span class="p">(</span>phantom_seed<span class="p">)</span><span class="w"></span></div><div class='line' id='LC2'><span class="c">% function []=arfi_scans_template(phantom_seed)</span></div><div class='line' id='LC3'><span class="c">% INPUTS:	</span></div><div class='line' id='LC4'><span class="c">%   phantom_seed (int) - scatterer position RNG seed</span></div><div class='line' id='LC5'><span class="c">% OUTPUTS:	</span></div><div class='line' id='LC6'><span class="c">%   Nothing returned, but lots of files and directories created in PATH</span></div><div class='line' id='LC7'>&nbsp;&nbsp;</div><div class='line' id='LC8'>&nbsp;</div><div class='line' id='LC9'><span class="c">%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%</span></div><div class='line' id='LC10'><span class="c">% MODIFICATION HISTORY</span></div><div class='line' id='LC11'><span class="c">%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%</span></div><div class='line' id='LC12'><span class="c">% Original script</span></div><div class='line' id='LC13'><span class="c">% Mark 04/11/08</span></div><div class='line' id='LC14'><span class="c">%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%</span></div><div class='line' id='LC15'><span class="c">% Removed PATH as a function input for SGE array job compatibility.</span></div><div class='line' id='LC16'><span class="c">%</span></div><div class='line' id='LC17'><span class="c">% Mark Palmeri (mark.palmeri@duke.edu)</span></div><div class='line' id='LC18'><span class="c">% 2009-01-04</span></div><div class='line' id='LC19'><span class="c">%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%</span></div><div class='line' id='LC20'><span class="c">% 2009-09-20 (mlp6)</span></div><div class='line' id='LC21'><span class="c">%</span></div><div class='line' id='LC22'><span class="c">% (1) Compute absolute number of scatterers needed from a defined scatterer</span></div><div class='line' id='LC23'><span class="c">% density to achieve fully developed speckle.</span></div><div class='line' id='LC24'><span class="c">%</span></div><div class='line' id='LC25'><span class="c">% (2) Changed zdisp.mat -&gt; zdisp.dat.</span></div><div class='line' id='LC26'><span class="c">%</span></div><div class='line' id='LC27'><span class="c">% (3) Corrected path definitions.</span></div><div class='line' id='LC28'><span class="c">%</span></div><div class='line' id='LC29'><span class="c">%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%</span></div><div class='line' id='LC30'><span class="c">% v2.5.0</span></div><div class='line' id='LC31'><span class="c">% * added PARAMS.TX_FNUM_Y and PARAMS.RX_FNUM_Y for defining the &#39;enabled&#39;</span></div><div class='line' id='LC32'><span class="c">%   matrix for xdc_2d_array probes; these parameters only have to be defined</span></div><div class='line' id='LC33'><span class="c">%   for the matrix probe type (currently, only the 4z1c)!!</span></div><div class='line' id='LC34'><span class="c">% Mark Palmeri (mlp6@duke.edu)</span></div><div class='line' id='LC35'><span class="c">% 2012-09-04</span></div><div class='line' id='LC36'><span class="c">%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%</span></div><div class='line' id='LC37'><span class="c">% v2.6.0</span></div><div class='line' id='LC38'><span class="c">% * removed TX_FNUM_Y and RX_FNUM_Y, and instead turned TX_FNUM and RX_FNUM</span></div><div class='line' id='LC39'><span class="c">%   into 2 element arrays</span></div><div class='line' id='LC40'><span class="c">% * added PARAMS.IMAGE_MODE (linear or phased) to help figure out how to do</span></div><div class='line' id='LC41'><span class="c">%   parallel rx later on, and general tracking in a phased configuration</span></div><div class='line' id='LC42'><span class="c">% Mark Palmeri (mlp6@duke.edu)</span></div><div class='line' id='LC43'><span class="c">% 2012-10-09</span></div><div class='line' id='LC44'><span class="c">%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%</span></div><div class='line' id='LC45'><br/></div><div class='line' id='LC46'><span class="c">% PATH TO URI/FIELD/TRACKING FILES:</span></div><div class='line' id='LC47'><span class="n">ULTRATRACK_PATH</span> <span class="p">=</span> <span class="s">&#39;/luscinia/vr16/StrainLiver/ultratrack/2.6.1&#39;</span><span class="p">;</span></div><div class='line' id='LC48'><span class="n">addpath</span><span class="p">(</span><span class="n">ULTRATRACK_PATH</span><span class="p">)</span></div><div class='line' id='LC49'><span class="n">addpath</span><span class="p">([</span><span class="n">ULTRATRACK_PATH</span> <span class="s">&#39;/URI_FIELD/code&#39;</span><span class="p">]);</span></div><div class='line' id='LC50'><span class="n">addpath</span><span class="p">([</span><span class="n">ULTRATRACK_PATH</span> <span class="s">&#39;/URI_FIELD/code/probes&#39;</span><span class="p">]);</span></div><div class='line' id='LC51'><span class="c">%addpath(&#39;/radforce/mlp6/arfi_code/sam/trunk/&#39;);</span></div><div class='line' id='LC52'><span class="n">addpath</span><span class="p">(</span><span class="s">&#39;/home/mlp6/matlab/Field_II_7.10&#39;</span><span class="p">);</span></div><div class='line' id='LC53'><span class="n">addpath</span><span class="p">(</span><span class="s">&#39;/luscinia/vr16/StrainLiver/trackingcode/simtrack&#39;</span><span class="p">);</span></div><div class='line' id='LC54'><br/></div><div class='line' id='LC55'><span class="c">% PARAMETERS FOR PHANTOM CREATION</span></div><div class='line' id='LC56'><span class="c">% file containing comma-delimited node data</span></div><div class='line' id='LC57'><span class="n">DYN_FILE</span><span class="p">=</span><span class="s">&#39;/radforce/fem/Veronica_3D_Strain/e0.01/nodes.dyn&#39;</span></div><div class='line' id='LC58'><span class="n">DEST_DIR</span> <span class="p">=</span> <span class="n">pwd</span><span class="p">;</span> </div><div class='line' id='LC59'><span class="n">DEST_DIR</span> <span class="p">=</span> <span class="p">[</span><span class="n">DEST_DIR</span> <span class="s">&#39;/&#39;</span><span class="p">];</span></div><div class='line' id='LC60'><span class="n">ZDISPFILE</span> <span class="p">=</span> <span class="p">[</span><span class="n">DEST_DIR</span> <span class="s">&#39;disp.dat&#39;</span><span class="p">];</span></div><div class='line' id='LC61'><br/></div><div class='line' id='LC62'><span class="c">% setup some Field II parameters</span></div><div class='line' id='LC63'><span class="n">PARAMS</span><span class="p">.</span><span class="n">field_sample_freq</span> <span class="p">=</span> <span class="mf">100e6</span><span class="p">;</span> <span class="c">% Hz</span></div><div class='line' id='LC64'><span class="n">PARAMS</span><span class="p">.</span><span class="n">c</span> <span class="p">=</span> <span class="mi">1540</span><span class="p">;</span> <span class="c">% sound speed (m/s)</span></div><div class='line' id='LC65'><br/></div><div class='line' id='LC66'><span class="c">% setup phantom parameters (PPARAMS)</span></div><div class='line' id='LC67'><span class="c">% leave any empty to use mesh limit</span></div><div class='line' id='LC68'><span class="n">PPARAMS</span><span class="p">.</span><span class="n">xmin</span><span class="p">=[</span><span class="o">-</span><span class="mf">0.5</span><span class="p">];</span><span class="n">PPARAMS</span><span class="p">.</span><span class="n">xmax</span><span class="p">=[</span><span class="mi">0</span><span class="p">];</span>	<span class="c">% out-of-plane,cm</span></div><div class='line' id='LC69'><span class="n">PPARAMS</span><span class="p">.</span><span class="n">ymin</span><span class="p">=[</span><span class="mi">0</span><span class="p">];</span><span class="n">PPARAMS</span><span class="p">.</span><span class="n">ymax</span><span class="p">=[</span><span class="mf">0.5</span><span class="p">];</span>	<span class="c">% lateral, cm \</span></div><div class='line' id='LC70'><span class="c">%PPARAMS.zmin=[-9.0];PPARAMS.zmax=[-0.1];% axial, cm   / X,Y SWAPPED vs FIELD!	</span></div><div class='line' id='LC71'><span class="n">PPARAMS</span><span class="p">.</span><span class="n">zmin</span><span class="p">=[</span><span class="o">-</span><span class="mf">7.0</span><span class="p">];</span><span class="n">PPARAMS</span><span class="p">.</span><span class="n">zmax</span><span class="p">=[</span><span class="o">-</span><span class="mf">5.0</span><span class="p">];</span><span class="c">% axial, cm   / X,Y SWAPPED vs FIELD!	</span></div><div class='line' id='LC72'><span class="n">PPARAMS</span><span class="p">.</span><span class="n">TIMESTEP</span><span class="p">=[];</span>	<span class="c">% Timesteps to simulate.  Leave empty to</span></div><div class='line' id='LC73'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="c">% simulate all timesteps</span></div><div class='line' id='LC74'><br/></div><div class='line' id='LC75'><span class="c">% compute number of scatteres to use</span></div><div class='line' id='LC76'><span class="n">SCATTERER_DENSITY</span> <span class="p">=</span> <span class="mi">27610</span><span class="p">;</span> <span class="c">% scatterers/cm^3</span></div><div class='line' id='LC77'><span class="n">TRACKING_VOLUME</span> <span class="p">=</span> <span class="p">(</span><span class="n">PPARAMS</span><span class="p">.</span><span class="n">xmax</span><span class="o">-</span><span class="n">PPARAMS</span><span class="p">.</span><span class="n">xmin</span><span class="p">)</span><span class="o">*</span><span class="p">(</span><span class="n">PPARAMS</span><span class="p">.</span><span class="n">ymax</span><span class="o">-</span><span class="n">PPARAMS</span><span class="p">.</span><span class="n">ymin</span><span class="p">)</span><span class="o">*</span><span class="p">(</span><span class="n">PPARAMS</span><span class="p">.</span><span class="n">zmax</span><span class="o">-</span><span class="n">PPARAMS</span><span class="p">.</span><span class="n">zmin</span><span class="p">);</span> <span class="c">% cm^3</span></div><div class='line' id='LC78'><span class="n">PPARAMS</span><span class="p">.</span><span class="n">N</span> <span class="p">=</span> <span class="nb">round</span><span class="p">(</span><span class="n">SCATTERER_DENSITY</span> <span class="o">*</span> <span class="n">TRACKING_VOLUME</span><span class="p">);</span> <span class="c">% number of scatterers to randomly distribute over the tracking volume</span></div><div class='line' id='LC79'><br/></div><div class='line' id='LC80'><span class="n">PPARAMS</span><span class="p">.</span><span class="n">seed</span><span class="p">=</span><span class="n">phantom_seed</span><span class="p">;</span>         <span class="c">% RNG seed</span></div><div class='line' id='LC81'><br/></div><div class='line' id='LC82'><span class="n">PPARAMS</span><span class="p">.</span><span class="n">delta</span><span class="p">=[</span><span class="mi">0</span> <span class="mi">0</span> <span class="mi">0</span><span class="p">]</span>   <span class="c">% rigid pre-zdisp-displacement scatterer translation,</span></div><div class='line' id='LC83'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="c">% in the dyna coordinate/unit system to simulate s/w</span></div><div class='line' id='LC84'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="c">% sequences</span></div><div class='line' id='LC85'><br/></div><div class='line' id='LC86'><span class="c">% PARAMETERS FOR SCANNING (PARAMS)</span></div><div class='line' id='LC87'><span class="n">PARAMS</span><span class="p">.</span><span class="n">PROBE_NAME</span><span class="p">=</span><span class="s">&#39;4z1c.txt&#39;</span><span class="p">;</span></div><div class='line' id='LC88'><span class="n">PARAMS</span><span class="p">.</span><span class="n">IMAGE_MODE</span><span class="p">=</span><span class="s">&#39;phased&#39;</span>  <span class="c">% &#39;linear&#39; or &#39;phased&#39; (help determine how to do parallel rx and matrix array work)</span></div><div class='line' id='LC89'><span class="n">PARAMS</span><span class="p">.</span><span class="n">XMIN</span><span class="p">=</span><span class="mi">0</span><span class="p">;</span>		    <span class="c">% Leftmost scan line (m)</span></div><div class='line' id='LC90'><span class="n">PARAMS</span><span class="p">.</span><span class="n">XSTEP</span><span class="p">=</span><span class="mf">0.1e-3</span><span class="p">;</span>	    <span class="c">% Lateral Scanline spacing (m)</span></div><div class='line' id='LC91'><span class="n">PARAMS</span><span class="p">.</span><span class="n">XMAX</span><span class="p">=</span><span class="mf">1.0e-3</span><span class="p">;</span>	    <span class="c">% Rightmost scan line (m)</span></div><div class='line' id='LC92'><span class="c">%PARAMS.YMIN=-1.0e-3;		    % Frontmost scan line (m)</span></div><div class='line' id='LC93'><span class="c">%PARAMS.YSTEP=0.1e-3;	    % Elev Scanline spacing (m)</span></div><div class='line' id='LC94'><span class="c">%PARAMS.YMAX=0;	    % Backmost scan line (m)</span></div><div class='line' id='LC95'><span class="n">PARAMS</span><span class="p">.</span><span class="n">YMIN</span><span class="p">=</span><span class="mi">0</span><span class="p">;</span></div><div class='line' id='LC96'><span class="n">PARAMS</span><span class="p">.</span><span class="n">YSTEP</span><span class="p">=</span><span class="mi">0</span><span class="p">;</span></div><div class='line' id='LC97'><span class="n">PARAMS</span><span class="p">.</span><span class="n">YMAX</span><span class="p">=</span><span class="mi">0</span><span class="p">;</span></div><div class='line' id='LC98'><span class="n">PARAMS</span><span class="p">.</span><span class="n">TX_FOCUS</span><span class="p">=[</span><span class="mi">0</span> <span class="mi">0</span> <span class="mf">6e-2</span><span class="p">];</span>    <span class="c">% Tramsmit focus depth (m)</span></div><div class='line' id='LC99'><span class="n">PARAMS</span><span class="p">.</span><span class="n">TX_F_NUM</span><span class="p">=[</span><span class="mi">2</span> <span class="mi">2</span><span class="p">];</span>      <span class="c">% Transmit f number (the &quot;y&quot; number only used for 2D matrix arrays)</span></div><div class='line' id='LC100'><span class="n">PARAMS</span><span class="p">.</span><span class="n">TX_FREQ</span><span class="p">=</span><span class="mf">6.0e6</span><span class="p">;</span>      <span class="c">% Transmit frequency (Hz)</span></div><div class='line' id='LC101'><span class="n">PARAMS</span><span class="p">.</span><span class="n">TX_NUM_CYCLES</span><span class="p">=</span><span class="mi">2</span><span class="p">;</span>     <span class="c">% Number of cycles in transmit toneburst</span></div><div class='line' id='LC102'><span class="n">PARAMS</span><span class="p">.</span><span class="n">RX_FOCUS</span><span class="p">=[</span><span class="mi">0</span> <span class="mi">0</span> <span class="mi">0</span><span class="p">];</span>          <span class="c">% Depth of receive focus - use 0 for dyn. foc</span></div><div class='line' id='LC103'><span class="n">PARAMS</span><span class="p">.</span><span class="n">RX_F_NUM</span><span class="p">=[</span><span class="mf">0.5</span> <span class="mf">0.5</span><span class="p">];</span>  <span class="c">% Receive aperture f number (the &quot;y&quot; number only used for 2D matrix arrays)</span></div><div class='line' id='LC104'><span class="n">PARAMS</span><span class="p">.</span><span class="n">RX_GROW_APERTURE</span><span class="p">=</span><span class="mi">1</span><span class="p">;</span>  </div><div class='line' id='LC105'><br/></div><div class='line' id='LC106'><span class="c">% lateral offset of the Tx beam from the Rx beam (m) to simulated prll rx</span></div><div class='line' id='LC107'><span class="c">% tracking (now a 2 element array, v2.6.0) (m)</span></div><div class='line' id='LC108'><span class="n">PARAMS</span><span class="p">.</span><span class="n">TXOFFSET</span> <span class="p">=</span> <span class="p">[</span><span class="mi">0</span> <span class="mi">0</span><span class="p">];</span>				</div><div class='line' id='LC109'><br/></div><div class='line' id='LC110'><span class="c">% TRACKING ALGORITHM TO USE</span></div><div class='line' id='LC111'><span class="c">% &#39;samtrack&#39;,&#39;samauto&#39;,&#39;ncorr&#39;,&#39;loupas&#39;</span></div><div class='line' id='LC112'><span class="n">TRACKPARAMS</span><span class="p">.</span><span class="n">TRACK_ALG</span><span class="p">=</span><span class="s">&#39;samtrack&#39;</span><span class="p">;</span></div><div class='line' id='LC113'><span class="n">TRACKPARAMS</span><span class="p">.</span><span class="n">WAVELENGTHS</span> <span class="p">=</span> <span class="mf">1.5</span><span class="p">;</span> <span class="c">% size of tracking kernel in wavelengths</span></div><div class='line' id='LC114'><span class="c">%TRACKPARAMS.KERNEL_SAMPLES = 85; % samples</span></div><div class='line' id='LC115'><span class="n">TRACKPARAMS</span><span class="p">.</span><span class="n">KERNEL_SAMPLES</span> <span class="p">=</span> <span class="nb">round</span><span class="p">((</span><span class="n">PARAMS</span><span class="p">.</span><span class="n">field_sample_freq</span><span class="o">/</span><span class="n">PARAMS</span><span class="p">.</span><span class="n">TX_FREQ</span><span class="p">)</span><span class="o">*</span><span class="n">TRACKPARAMS</span><span class="p">.</span><span class="n">WAVELENGTHS</span><span class="p">);</span></div><div class='line' id='LC116'><br/></div><div class='line' id='LC117'><br/></div><div class='line' id='LC118'><span class="c">% MAKE PHANTOMS</span></div><div class='line' id='LC119'><span class="n">P</span><span class="p">=</span><span class="n">rmfield</span><span class="p">(</span><span class="n">PPARAMS</span><span class="p">,</span><span class="s">&#39;TIMESTEP&#39;</span><span class="p">);</span></div><div class='line' id='LC120'><span class="n">PHANTOM_DIR</span><span class="p">=[</span><span class="n">make_file_name</span><span class="p">([</span><span class="n">DEST_DIR</span> <span class="s">&#39;v_phantom_short&#39;</span><span class="p">],</span><span class="n">P</span><span class="p">)</span> <span class="s">&#39;/&#39;</span><span class="p">];</span></div><div class='line' id='LC121'><span class="n">unix</span><span class="p">(</span><span class="n">sprintf</span><span class="p">(</span><span class="s">&#39;mkdir %s&#39;</span><span class="p">,</span><span class="n">PHANTOM_DIR</span><span class="p">));</span> <span class="c">% mkdir(PHANTOM_DIR); %matlab 7</span></div><div class='line' id='LC122'><span class="n">PHANTOM_FILE</span><span class="p">=[</span><span class="n">PHANTOM_DIR</span> <span class="s">&#39;phantom&#39;</span><span class="p">];</span></div><div class='line' id='LC123'><span class="n">mkphantomfromdyna3</span><span class="p">(</span><span class="n">DYN_FILE</span><span class="p">,</span><span class="n">ZDISPFILE</span><span class="p">,</span><span class="n">PHANTOM_FILE</span><span class="p">,</span><span class="n">PPARAMS</span><span class="p">);</span></div><div class='line' id='LC124'><br/></div><div class='line' id='LC125'><span class="c">% SCAN PHANTOMS</span></div><div class='line' id='LC126'><span class="n">RF_DIR</span><span class="p">=[</span><span class="n">make_file_name</span><span class="p">([</span><span class="n">PHANTOM_DIR</span> <span class="s">&#39;rf&#39;</span><span class="p">],</span><span class="n">PARAMS</span><span class="p">)</span> <span class="s">&#39;/&#39;</span><span class="p">];</span></div><div class='line' id='LC127'><span class="n">unix</span><span class="p">(</span><span class="n">sprintf</span><span class="p">(</span><span class="s">&#39;mkdir %s&#39;</span><span class="p">,</span><span class="n">RF_DIR</span><span class="p">));</span> <span class="c">% mkdir(RF_DIR); %matlab 7</span></div><div class='line' id='LC128'><span class="n">RF_FILE</span><span class="p">=[</span><span class="n">RF_DIR</span> <span class="s">&#39;rf&#39;</span><span class="p">];</span></div><div class='line' id='LC129'><span class="n">field_init</span><span class="p">(</span><span class="o">-</span><span class="mi">1</span><span class="p">);</span></div><div class='line' id='LC130'><span class="n">do_dyna_scans</span><span class="p">(</span><span class="n">PHANTOM_FILE</span><span class="p">,</span><span class="n">RF_FILE</span><span class="p">,</span><span class="n">PARAMS</span><span class="p">);</span></div><div class='line' id='LC131'><span class="n">field_end</span><span class="p">;</span></div><div class='line' id='LC132'><br/></div><div class='line' id='LC133'><span class="c">%% TRACK RF</span></div><div class='line' id='LC134'><span class="c">%TRACK_DIR=[make_file_name([RF_DIR &#39;track&#39;],TRACKPARAMS) &#39;/&#39;];</span></div><div class='line' id='LC135'><span class="c">%unix(sprintf(&#39;mkdir %s&#39;,TRACK_DIR)); % mkdir(TRACK_DIR); %matlab 7</span></div><div class='line' id='LC136'><br/></div><div class='line' id='LC137'><span class="c">%% load all RF into a big matrix</span></div><div class='line' id='LC138'><span class="c">%n=1;</span></div><div class='line' id='LC139'><br/></div><div class='line' id='LC140'><span class="c">%while ~isempty(dir(sprintf(&#39;%s%03d.mat&#39;,RF_FILE,n)))</span></div><div class='line' id='LC141'><span class="c">%    load(sprintf(&#39;%s%03d.mat&#39;,RF_FILE,n));</span></div><div class='line' id='LC142'><span class="c">%    % some rf*.mat files are off by one axial index; allowing for some dynamic</span></div><div class='line' id='LC143'><span class="c">%    % assignment of bigRF matrix</span></div><div class='line' id='LC144'><span class="c">%    % bigRF(:,:,n)=rf;</span></div><div class='line' id='LC145'><span class="c">%    bigRF(1:size(rf,1),:,n)=rf;</span></div><div class='line' id='LC146'><span class="c">%    n=n+1;</span></div><div class='line' id='LC147'><span class="c">%end;</span></div><div class='line' id='LC148'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div><div class='line' id='LC149'><span class="c">%% track the displacements</span></div><div class='line' id='LC150'><span class="c">%%[D,C]=estimate_disp(bigRF,TRACKPARAMS.TRACK_ALG,TRACKPARAMS.KERNEL_SAMPLES);</span></div><div class='line' id='LC151'><span class="c">%[D,C]=estimate_disp(bigRF,TRACKPARAMS);</span></div><div class='line' id='LC152'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div><div class='line' id='LC153'><span class="c">%% save res_tracksim.mat (same format as experimental res*.mat files)</span></div><div class='line' id='LC154'><span class="c">%track_save_path = pwd;</span></div><div class='line' id='LC155'><span class="c">%createtrackres(C,D,PARAMS,PPARAMS,PHANTOM_FILE,RF_FILE,TRACKPARAMS,TRACK_DIR);</span></div></pre></div></td>
          </tr>
        </table>
  </div>

  </div>
</div>

<a href="#jump-to-line" rel="facebox[.linejump]" data-hotkey="l" class="js-jump-to-line" style="display:none">Jump to Line</a>
<div id="jump-to-line" style="display:none">
  <form accept-charset="UTF-8" class="js-jump-to-line-form">
    <input class="linejump-input js-jump-to-line-field" type="text" placeholder="Jump to line&hellip;" autofocus>
    <button type="submit" class="button">Go</button>
  </form>
</div>

        </div>

      </div><!-- /.repo-container -->
      <div class="modal-backdrop"></div>
    </div><!-- /.container -->
  </div><!-- /.site -->


    </div><!-- /.wrapper -->

      <div class="container">
  <div class="site-footer">
    <ul class="site-footer-links right">
      <li><a href="https://status.github.com/">Status</a></li>
      <li><a href="http://developer.github.com">API</a></li>
      <li><a href="http://training.github.com">Training</a></li>
      <li><a href="http://shop.github.com">Shop</a></li>
      <li><a href="/blog">Blog</a></li>
      <li><a href="/about">About</a></li>

    </ul>

    <a href="/">
      <span class="mega-octicon octicon-mark-github" title="GitHub"></span>
    </a>

    <ul class="site-footer-links">
      <li>&copy; 2014 <span title="0.04294s from github-fe123-cp1-prd.iad.github.net">GitHub</span>, Inc.</li>
        <li><a href="/site/terms">Terms</a></li>
        <li><a href="/site/privacy">Privacy</a></li>
        <li><a href="/security">Security</a></li>
        <li><a href="/contact">Contact</a></li>
    </ul>
  </div><!-- /.site-footer -->
</div><!-- /.container -->


    <div class="fullscreen-overlay js-fullscreen-overlay" id="fullscreen_overlay">
  <div class="fullscreen-container js-fullscreen-container">
    <div class="textarea-wrap">
      <textarea name="fullscreen-contents" id="fullscreen-contents" class="js-fullscreen-contents" placeholder="" data-suggester="fullscreen_suggester"></textarea>
          <div class="suggester-container">
              <div class="suggester fullscreen-suggester js-navigation-container" id="fullscreen_suggester"
                 data-url="/Duke-Ultrasound/ultratrack/suggestions/commit">
              </div>
          </div>
    </div>
  </div>
  <div class="fullscreen-sidebar">
    <a href="#" class="exit-fullscreen js-exit-fullscreen tooltipped leftwards" title="Exit Zen Mode">
      <span class="mega-octicon octicon-screen-normal"></span>
    </a>
    <a href="#" class="theme-switcher js-theme-switcher tooltipped leftwards"
      title="Switch themes">
      <span class="octicon octicon-color-mode"></span>
    </a>
  </div>
</div>



    <div id="ajax-error-message" class="flash flash-error">
      <span class="octicon octicon-alert"></span>
      <a href="#" class="octicon octicon-remove-close close js-ajax-error-dismiss"></a>
      Something went wrong with that request. Please try again.
    </div>

  </body>
</html>

